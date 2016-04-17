/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package luxuryliving;

/**
 *
 * @author Sarthak
 */
public class Hotel {
    
    Node head;
    
    public class Node {
        String name, dest;
        int dob;
        Node next;
        
        public Node(String n, String d, int y) {
            name = n;
            dest = d;
            dob = y;
            next = null;
        }
    }
    
    public Hotel() {
        head = null;
    }
    
    public Hotel(Node n) {
        head = n;
        n.next = null;
    }
    
    public void add(String name, String dest, int yr) {
        Node n = new Node(name, dest, yr);
        n.next = head;
        head = n;        
    } 
    
    public void print(Node head) {
        Node temp = head;
        int i = 1;
        while(temp != null) {
            System.out.println("No." + i + " " + temp.name + " " + temp.dest + " " + temp.dob);
            temp = temp.next;
            i++;
        }
    }
    
    public static int length(Node head) {
        Node temp = head;
        int n = 0;
        while(temp != null) {
            n++;
            temp = temp.next;
        }
        return n;
    }
    
    public void getByName() {
        int len = length(head), i = 0;
        
        while(i < len - 1) {
            Node curr = head, prev = null;
            while(curr.next != null) {
                if((curr.name).compareTo(curr.next.name) >= 0){
                    //System.out.println(curr.name + " is bigger than " + curr.next.name);
                    Node nextNode = curr.next;
                    if(prev == null) {
                        curr.next = nextNode.next;
                        nextNode.next = curr;
                        prev = nextNode;
                        head = prev;                       
                    }
                    else {
                        curr.next = nextNode.next;
                        nextNode.next = curr;
                        prev.next = nextNode;
                        prev = nextNode;
                    }
                }
                else {
                    prev = curr;
                    curr = curr.next;
                }
            }
            i++;
        }
        print(head);
    }
    
    public void getByDate() {
        int len = length(head), i = 0;
        
        while(i < len - 1) {
            Node curr = head, prev = null;
            while(curr.next != null) {
                if(curr.dob > curr.next.dob){
                    //System.out.println("changed");
                    Node nextNode = curr.next;
                    if(prev == null) {
                        curr.next = nextNode.next;
                        nextNode.next = curr;
                        prev = nextNode;
                        head = prev;                       
                    }
                    else {
                        curr.next = nextNode.next;
                        nextNode.next = curr;
                        prev.next = nextNode;
                        prev = nextNode;
                    }
                }
                else {
                    prev = curr;
                    curr = curr.next;
                }
            }
            i++;
        }
        print(head);
        
    }
    
    public void fibo(int n) {
        if(n == 0) {
            System.out.println(n);
            return;
        }
        if(n == 1) {
            System.out.println("0 1");
            return;
        }
        System.out.print("0 1");    
        int a = 0, b = 1;
        int c = a + b;
        while(c <= n) {
            System.out.print(" " + c);
            a = b;
            b = c;
            c = a + b;
        }
        System.out.println();
    }
    
    public static void main(String[] args) {
        Hotel h = new Hotel();
        h.add("taj", "delhi", 1960);
        h.add("oberoi", "delhi", 1990);
        h.add("itc", "delhi", 2000);
        h.add("jaypee", "mumbai", 1970);
        h.add("hilton", "gurgaon", 1980);
        System.out.println("Getting oldest hotels: ");
        h.getByDate();    
        System.out.println("Getting hotels by name: ");
        h.getByName();            
        System.out.println("Fibonacci series is as follows: ");
        h.fibo(130);
    }
    
}
