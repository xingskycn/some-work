//
//  APUDPHandler.m
//  AP
//
//  Created by Ziehn Nils on 8/6/11.
//  Copyright 2011 ziehn. All rights reserved.
//

#import "APUDPHandler.h"

#if ! defined(UDPECHO_IPV4_ONLY)
	#define UDPECHO_IPV4_ONLY 0
#endif

#include <sys/socket.h>
#include <netinet/in.h>
#include <unistd.h>

@implementation APUDPHandler
@synthesize delegate;
@synthesize port;
@synthesize hostName;
@synthesize hostAddress;


- (void)sendData:(NSData *)data toAddress:(NSData *)addr
{
    int                     err;
    int                     sock;
    ssize_t                 bytesWritten;
    const struct sockaddr * addrPtr;
    socklen_t               addrLen;
	
    sock = CFSocketGetNative(self->cfSocket);
	
	addrPtr = [addr bytes];
	addrLen = (socklen_t) [addr length];
    
    bytesWritten = sendto(sock, [data bytes], [data length], 0, addrPtr, addrLen);
    if (bytesWritten < 0) {
        err = errno;
    } else  if (bytesWritten == 0) {
        err = EPIPE;                    
    } else {
        // We ignore any short writes, which shouldn't happen for UDP anyway.
        assert( (NSUInteger) bytesWritten == [data length] );
        err = 0;
    }
	
    if (err == 0) {
        if ( (self.delegate != nil) && [self.delegate respondsToSelector:@selector(echo:didSendData:toAddress:)] ) {
            [self.delegate sender:self didSendData:data toAddress:addr];
        }
    } else {
        if ( (self.delegate != nil) && [self.delegate respondsToSelector:@selector(echo:didFailToSendData:toAddress:error:)] ) {
            [self.delegate sender:self didFailToSendData:data toAddress:addr error:[NSError errorWithDomain:NSPOSIXErrorDomain code:err userInfo:nil]];
        }
    }
}

- (void)readData
{
    int                     err;
    int                     sock;
    struct sockaddr_storage addr;
    socklen_t               addrLen;
    uint8_t                 buffer[65536];
    ssize_t                 bytesRead;
    
    sock = CFSocketGetNative(self->cfSocket);
    
    addrLen = sizeof(addr);
    bytesRead = recvfrom(sock, buffer, sizeof(buffer), 0, (struct sockaddr *) &addr, &addrLen);
    if (bytesRead < 0) {
        err = errno;
    } else if (bytesRead == 0) {
        err = EPIPE;
    } else {
        NSData *    dataObj;
        NSData *    addrObj;
		
        err = 0;
		
        dataObj = [NSData dataWithBytes:buffer length:bytesRead];
        assert(dataObj != nil);
        addrObj = [NSData dataWithBytes:&addr  length:addrLen  ];
        assert(addrObj != nil);
		
        // Tell the delegate about the data.
        
        if ( (self.delegate != nil) && [self.delegate respondsToSelector:@selector(echo:didReceiveData:fromAddress:)] ) {
            [self.delegate sender:self didReceiveData:dataObj fromAddress:addrObj];
        }
    }
    
    // If we got an error, tell the delegate.
    
    if (err != 0) {
        if ( (self.delegate != nil) && [self.delegate respondsToSelector:@selector(echo:didReceiveError:)] ) {
            [self.delegate sender:self didReceiveError:[NSError errorWithDomain:NSPOSIXErrorDomain code:err userInfo:nil]];
        }
    }
}

static void SocketReadCallback(CFSocketRef s, CFSocketCallBackType type, CFDataRef address, const void *data, void *info)
{
    APUDPHandler* obj;
    
    obj = (APUDPHandler *) info;
    
    [obj readData];
}       

- (BOOL)setupSocketConnectedToAddress:(NSData *)address port:(NSUInteger)aPort error:(NSError **)errorPtr
{
	int                     err;
	int                     junk;
	int                     sock;
	const CFSocketContext   context = { 0, self, NULL, NULL, NULL };
	CFRunLoopSourceRef      rls;
	
	// Create the UDP socket itself.
	err = 0;
	sock = socket(AF_INET, SOCK_DGRAM, 0);
	if (sock < 0) {
		err = errno;
	}
	
	// Bind or connect the socket, depending on whether we're in server or client mode.
	
	if (err == 0) {
		struct sockaddr_in addr;
		
		memset(&addr, 0, sizeof(addr));
		if (address == nil) {
			// Server mode.  Set up the address based on the socket family of the socket 
			// that we created, with the wildcard address and the caller-supplied port number.
			addr.sin_len         = sizeof(addr);
			addr.sin_family      = AF_INET;
			addr.sin_port        = htons(aPort);
			addr.sin_addr.s_addr = INADDR_ANY;
			err = bind(sock, (const struct sockaddr *) &addr, sizeof(addr));
		} else {
			// Client mode.  Set up the address on the caller-supplied address and port 
			// number.
			if ([address length] > sizeof(addr)) {
				[address getBytes:&addr length:sizeof(addr)];
			} else {
				[address getBytes:&addr length:[address length]];
			}
			assert(addr.sin_family == AF_INET);
			addr.sin_port = htons(aPort);
			err = connect(sock, (const struct sockaddr *) &addr, sizeof(addr));
		}
		if (err < 0) {
			err = errno;
		}
	}
	
	// Wrap the socket in a CFSocket that's scheduled on the runloop.
	
	if (err == 0) {
		self->cfSocket = CFSocketCreateWithNative(NULL, sock, kCFSocketReadCallBack, SocketReadCallback, &context);
		
		// The socket will now take care of cleaning up our file descriptor.
		
		sock = -1;
		
		rls = CFSocketCreateRunLoopSource(NULL, self->cfSocket, 0);
		
		CFRunLoopAddSource(CFRunLoopGetCurrent(), rls, kCFRunLoopDefaultMode);
		
		CFRelease(rls);
	}
	
	// Handle any errors.
	
	if (sock != -1) {
		junk = close(sock);
		assert(junk == 0);
	}

	if ( (self->cfSocket == NULL) && (errorPtr != NULL) ) {
		*errorPtr = [NSError errorWithDomain:NSPOSIXErrorDomain code:err userInfo:nil];
	}
	
	return (err == 0);
}

- (void)hostResolutionDone
{
    NSError *           error;
    Boolean             resolved;
    NSArray *           resolvedAddresses;
    
    error = nil;
    
    // Walk through the resolved addresses looking for one that we can work with.
    
    resolvedAddresses = (NSArray *) CFHostGetAddressing(self->cfHost, &resolved);
    if ( resolved && (resolvedAddresses != nil) ) {
        for (NSData * address in resolvedAddresses) {
            BOOL                    success;
            const struct sockaddr * addrPtr;
            NSUInteger              addrLen;
            
            addrPtr = (const struct sockaddr *) [address bytes];
            addrLen = [address length];
            assert(addrLen >= sizeof(struct sockaddr));
			
            // Try to create a connected CFSocket for this address.  If that fails, 
            // we move along to the next address.  If it succeeds, we're done.
            
            success = NO;
            if ( 
                (addrPtr->sa_family == AF_INET) 
				) {
                success = [self setupSocketConnectedToAddress:address port:self.port error:&error];
                if (success) {
                    CFDataRef aHostAddress;
                    
                    aHostAddress = CFSocketCopyPeerAddress(self->cfSocket);
                    
                    self.hostAddress = (NSData *) aHostAddress;
                    
                    CFRelease(aHostAddress);
                }
            }
            if (success) {
                break;
            }
        }
    }
    
    // If we didn't get an address and didn't get an error, synthesise a host not found error.
    
    if ( (self.hostAddress == nil) && (error == nil) ) {
        error = [NSError errorWithDomain:(NSString *)kCFErrorDomainCFNetwork code:kCFHostErrorHostNotFound userInfo:nil];
    }
	
    if (error == nil) {
        // We're done resolving, so shut that down.
		
        [self stopHostResolution];
		
        // Tell the delegate that we're up.
        
        if ( (self.delegate != nil) && [self.delegate respondsToSelector:@selector(echo:didStartWithAddress:)] ) {
            [self.delegate sender:self didStartWithAddress:self.hostAddress];
        }
    } else {
        [self stopWithError:error];
    }
}

static void HostResolveCallback(CFHostRef theHost, CFHostInfoType typeInfo, const CFStreamError *error, void *info)
// This C routine is called by CFHost when the host resolution is complete. 
// It just redirects the call to the appropriate Objective-C method.
{
    APUDPHandler *    obj;
    
    obj = (APUDPHandler *) info;
    assert([obj isKindOfClass:[APUDPHandler class]]);
    
#pragma unused(theHost)
    assert(theHost == obj->cfHost);
#pragma unused(typeInfo)
    assert(typeInfo == kCFHostAddresses);
    
    if ( (error != NULL) && (error->domain != 0) ) {
        [obj stopWithStreamError:*error];
    } else {
        [obj hostResolutionDone];
    }
}

- (void)startConnectedToHostName:(NSString *)aHostName port:(NSUInteger)aPort
{
    if (self.port == 0) {
        Boolean             success;
        CFHostClientContext context = {0, self, NULL, NULL, NULL};
        CFStreamError       streamError;
		
        self->cfHost = CFHostCreateWithName(NULL, (CFStringRef) aHostName);
        
        CFHostSetClient(self->cfHost, HostResolveCallback, &context);
        
        CFHostScheduleWithRunLoop(self->cfHost, CFRunLoopGetCurrent(), kCFRunLoopDefaultMode);
        
        success = CFHostStartInfoResolution(self->cfHost, kCFHostAddresses, &streamError);
        if (success) {
            self.hostName = aHostName;
            self.port = aPort;
            // ... continue in HostResolveCallback
        }
    }
}

- (void)sendData:(NSData *)data
{
    [self sendData:data toAddress:nil];
}

- (void)stopHostResolution
// Called to stop the CFHost part of the object, if it's still running.
{
    if (self->cfHost != NULL) {
        CFHostSetClient(self->cfHost, NULL, NULL);
        CFHostCancelInfoResolution(self->cfHost, kCFHostAddresses);
        CFHostUnscheduleFromRunLoop(self->cfHost, CFRunLoopGetCurrent(), kCFRunLoopDefaultMode);
        CFRelease(self->cfHost);
        self->cfHost = NULL;
    }
}

- (void)stop
{
    self.hostName = nil;
    self.hostAddress = nil;
    self.port = 0;
    [self stopHostResolution];
    if (self->cfSocket != NULL) {
        CFSocketInvalidate(self->cfSocket);
        CFRelease(self->cfSocket);
        self->cfSocket = NULL;
    }
}

- (void)stopWithError:(NSError *)error
// Stops the object, reporting the supplied error to the delegate.
{
    assert(error != nil);
    [self stop];
    if ( (self.delegate != nil) && [self.delegate respondsToSelector:@selector(echo:didStopWithError:)] ) {
        [[self retain] autorelease];
        [self.delegate sender:self didStopWithError:error];
    }
}

- (void)stopWithStreamError:(CFStreamError)streamError
// Stops the object, reporting the supplied error to the delegate.
{
    NSDictionary *  userInfo;
    NSError *       error;
	
    if (streamError.domain == kCFStreamErrorDomainNetDB) {
        userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
					[NSNumber numberWithInteger:streamError.error], kCFGetAddrInfoFailureKey,
					nil
					];
    } else {
        userInfo = nil;
    }
    error = [NSError errorWithDomain:(NSString *)kCFErrorDomainCFNetwork code:kCFHostErrorUnknown userInfo:userInfo];
    assert(error != nil);
    
    [self stopWithError:error];
}



@end
