#!/usr/bin/perl -w
## -w enables warnings
 
use strict;
use warnings;
use threads;

use IO::Socket::INET;
 
my $port = shift || die "[!] No port given...\n";;  ##  Value given from terminal
my $socket = IO::Socket::INET->new(
        LocalPort       => $port,  ##  The connection will stay local
        Proto           => 'tcp',
        Listen          => SOMAXCONN ) || die "[!] Can not establish Socket...\n";
 
print "Listening for connections on $port\n";


##  While loop to accept connections
while (my $client = $socket->accept) {
        my $addr = gethostbyaddr($client->peeraddr, AF_INET);
        my $port = $client->peerport;

        sub threaded_task {
                my ($id, $second)=@_;
                # print "T1_Starting thread $id\n";
                while(<STDIN>){
                        print $client $_;
                        print "--- Sent\n"
                }
                # print "T1_Ending thread $id\n";
        }
        #Receive
        sub threaded_task2 {
                my ($id, $second)=@_;
                # print "T2_Starting thread $id\n";
                while (<$client>) {
                        print "[Client:$port] $_";  ##  Print the client port and the message recived
                        # print $client "$.: $_";
                }
                # print "T2_Ending thread $id\n";
        }

        print "You can communicate now !\n\n";
        my $thread1=threads->create(\&threaded_task, "thread1", 1);
        my $thread2=threads->create(\&threaded_task2, "thread2", 2);

        $thread2->join();


                
                # my $c = <$client>;
                # if($c){
                #         print "[Client:$port] $c";  ##  Print the client port and the message recived
                #         print $client "$.: $c";    
                # }else{
                #         last
                # }    
        
        close $client || die "[!] Connection unable to close...\n";
        die "[!] Can not connect $!\n";
}