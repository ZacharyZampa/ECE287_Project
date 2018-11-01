/* DES encryption: Java Implementation
 * Authors: Jayson Rook and Zachary Zampa
 * Created: Fall 2018
 * Class: ECE 287
 * 
 * Extra Information:
 * Hardware is set for 64bits (8bytes) of data which means up to 4 chars can be used
 */
import java.util.Scanner;

public class DESEncryption {
	
	public static Scanner keyboard = new Scanner(System.in); // keyboard input

	public static void main(String[] args) {
		// set up variables
		String ogString = "", newString = "";
		System.out.print("Enter 4 characters through .txt file or manually?");
		if ("manually".equals(keyboard.next()))
		{
			
			System.out.printf("Enter 4 characters ");
			for (int count = 0; count < 4; count++)                   // Array instead?
			{
				ogString = ogString + keyboard.next(); // load characters into string
			}
		}
		else // do .txt file processing
		{
			System.out.print("Input .txt file");
			
		}
		
		newString = des(ogString);
		
		

	} // end main method
	
	// encrypt user input
	public static String des(String ogString) {                      // Array instead?
		
		
		return null; //return modified input
	} // end des method
}
