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
import java.util.Random;



public class DES_Encryption {
   
   public static Scanner keyboard = new Scanner(System.in); // keyboard input
   
   public static void main(String[] args) {
      // initialize variables
      int[] key = new int[] {1, 2, 3, 4, 5, 6, 7, 8, 9, 
	      10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 
	      20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 
	      30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 
	      40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 
	      50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 
	      60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 
	      70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 
	      80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 
	      90, 91, 92, 93, 94, 95, 96, 97, 98, 99, 100};
      System.out.print("process ints or chars? ");
      char choice = keyboard.next().charAt(0);
      if (choice == 'i' || choice == 'I')
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
       char[] ogInput =  new char [4]; // original input
       char[] rpt = new char [2]; // altered text: RPT
       char[] lpt = new char [2]; // altered text: LPT
       charProcess(ogInput);
      
      
      
      // ***Step 1: Permutation
      Random rgen = new Random(); // random number generation 
      for (int i = 0; i < ogInput.length; i++)
      {
	  int shuffle = rgen.nextInt(ogInput.length); // probably set random number to array so encrypted data can be decrypted
	  char temp = ogInput[i];
	  ogInput[i] = ogInput[shuffle];
	  ogInput[shuffle] = temp;
      }
      
      //test
      System.out.println("Permutated: ");
      for (int i = 0; i < ogInput.length; i++)
      {
	 System.out.print(ogInput[i]); 
      }
      
      // split into two 32 bit blocks
      lpt[0] = ogInput[0];
      lpt[1] = ogInput[1];
      rpt[0] = ogInput[2];
      rpt[1] = ogInput[3];
      
      
      // ***Step 2: 16 rounds
      
      
      
      
      
      
      // Step 3: Final Permutation
   } // end desChar method
   
   // encrypt user input int
   public static void desInt(int[] key) {
      int[] ogInput =  new int [64]; // original input 
      intProcess(ogInput);
      
   } // end desInt method
   
   // create int array to process
   public static int[] intProcess(int[] ogInput)
   {
      
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
            e.printStackTrace();
         }
         int i = 0;
         while(scanFile.hasNextInt()){
            ogInput[i++] = scanFile.nextInt();
         }
         
      }
      
      return ogInput;
      
   } // end intProcess method
   
   // create char array to process
   public static char[] charProcess(char[] ogInput)
   {
      
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
            e.printStackTrace();
         }
         int i = 0;
         while(scanFile.hasNext()){
            ogInput[i++] = scanFile.next().charAt(0);
         }
         
      }
      
      return ogInput;
      
   } // end charProcess method
   
}
