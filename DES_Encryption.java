
/* DES encryption: Java Implementation
 * Authors: Jayson Rook and Zachary Zampa
 * Created: Fall 2018
 * Class: ECE 287
 * 
 * Extra Information:
 * Hardware is set for 64bits (8bytes) of data which means up to 4 chars can be used
 */
import java.io.File;
import java.io.FileNotFoundException;
import java.util.Scanner;


public class DES_Encryption {
	
	public static Scanner keyboard = new Scanner(System.in); // keyboard input
	
	public static void main(String[] args) {
		// initialize variables
		int[] key = new int [64];             // replace with desired key
			
		System.out.print("process ints or chars? ");
		if (keyboard.next().charAt(0) == 'i' || keyboard.next().charAt(0) == 'I')
		{
			desInt(key);
		}
			
		else // invoke char processing method
		{
			desChar(key);
		}
			
			
	
			
			

		} // end main method
		
		// encrypt user input char
		public static void desChar(int[] key) {                     
			charProcess(key);
			
		} // end desChar method
		
		// encrypt user input int
		public static void desInt(int[] key) {                     
			intProcess(key);
					
		} // end desInt method
		
		// process ints
		public static void intProcess(int key[])
		{
			
			int[] ogInput =  new int [64]; // original input 
			
			System.out.print("manual or .txt file input? ");
			if ("manual".equals(keyboard.next()))
			{
					
				System.out.printf("Enter 64 integers ");
				for (int count = 0; count < 64; count++)           
				{
					ogInput[count] = keyboard.nextInt();
				}
			}
			else // do .txt file processing
			{
				System.out.print("Input .txt file");
				Scanner scanFile = null;
				try {
					scanFile = new Scanner(new File(keyboard.next()));
				} catch (FileNotFoundException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
				int i = 0;
				while(scanFile.hasNextInt()){
				   ogInput[i++] = scanFile.nextInt();
				}
	
			}
				
				
			System.out.print("Encryption or Decryption: ");
			char choice = keyboard.next().charAt(0);
			keyboard.close();	
			
		} // end intProcess method
		
		// process chars
		public static void charProcess(int key[])
		{
			
			char[] ogInput =  new char [4]; // original input 
			
			System.out.print("manual or .txt file input? ");
			if ("manual".equals(keyboard.next()))
			{
					
				System.out.printf("Enter 4 chars ");
				for (int count = 0; count < 4; count++)           
				{
					ogInput[count] = keyboard.next().charAt(0);
				}
			}
			else // do .txt file processing
			{
				System.out.print("Input .txt file");
				Scanner scanFile = null;
				try {
					scanFile = new Scanner(new File(keyboard.next()));
				} catch (FileNotFoundException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
				int i = 0;
				while(scanFile.hasNext()){
				   ogInput[i++] = scanFile.next().charAt(0);
				}
	
			}
				
				
			System.out.print("Encryption or Decryption: ");
			char choice = keyboard.next().charAt(0);
			keyboard.close();	
			
		} // end charProcess method

}
	
