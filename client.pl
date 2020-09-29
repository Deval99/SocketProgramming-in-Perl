#!/usr/bin/perl -w
 
use strict;
use warnings;
use threads;
use IO::Socket::INET;
 
my $server = shift;  ##  If this were remote it would be an IP, but localhost for now
my $port = shift;  ##  Same as before
 
my $socket = IO::Socket::INET->new(
        PeerAddr        => $server,
        PeerPort        => $port,
        Proto           => 'tcp' ) || die "[!] Can not connect to $server:$port\n";
 
print "Establishing connection to $server:$port\n";
 
##  Our interactive loop
sub threaded_task {
		my ($id, $second)=@_;
        # print "T1_Starting thread $id\n";
        while(<STDIN>){
                print $socket $_;
                print "--- Sent\n"
        }
        # print "T1_Ending thread $id\n";
}
#Receive
sub threaded_task2 {
        my ($id, $second)=@_;
        # print "T2_Starting thread $thr_id\n";
        while (<$socket>) {
                print "[Server:$port] $_";  ##  Print the client port and the message recived
                # print $socket "$.: $_";
        }
        # print "T2_Ending thread $thr_id\n";
}
print "You can communicate now !\n\n";
my $thread1=threads->create(\&threaded_task, "thread1", 1);
my $thread2=threads->create(\&threaded_task2, "thread2", 2);

$thread2->join();


close $socket || die "[!] Can not close connection...\n";  ##  Always gotta close