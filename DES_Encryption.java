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

		String strKey = "133457799BBCDFF1";
		boolean[][] subKeys = generateSubKeys(strKey);

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

	// Permuted choice lookup tables
	public static int[] pc1 = new int[] {57, 49, 41, 33, 25, 17, 9, 
			1, 58, 50, 42, 34, 26, 18, 
			10, 2, 59, 51, 43, 35, 27, 
			19, 11, 3, 60, 52, 44, 36, 
			63, 55, 47, 39, 31, 23, 15, 
			7, 62, 54, 46, 38, 30, 22, 
			14, 6, 61, 53, 45, 37, 29, 
			21, 13, 5, 28, 20, 12, 4};

	public static int[] pc2 = new int[] {14, 17, 11, 24, 1, 5, 3, 
			28, 15, 6, 21, 10, 23, 19, 
			12, 4, 26, 8, 16, 7, 27, 
			20, 13, 2, 41, 52, 31, 37, 
			47, 55, 30, 40, 51, 45, 33, 
			48, 44, 49, 39, 56, 34, 53, 
			46, 42, 50, 36, 29, 32};

	// Given a hexadecmial key, generate the 16 subkeys needed for the encryption algorithm
	public static boolean[][] generateSubKeys(String strKey) {
		boolean[] key = new boolean[64];
		String bits = Long.toString(Long.parseLong(strKey.toLowerCase(), 16), 2);
		int bit = 63;
		for (int i = 0; i < bits.length(); i++) {
			key[bit] = bits.charAt(bits.length() - 1 - i) == '1';
			bit--;
		}

		//displayBits(key, 8); // show the key converted from hex to binary

		boolean[] permutedKey = new boolean[56];
		for (int i = 0; i < 56; i++) {
			permutedKey[i] = key[pc1[i]-1];
		}

		boolean[][] C = new boolean[17][28];
		boolean[][] D = new boolean[17][28];

		for (int i = 0; i < 28; i++) {
			C[0][i] = permutedKey[i];
			D[0][i] = permutedKey[i+28];
		}

		int[] shiftSize = new int[] {1, 1, 2, 2, 2, 2, 2, 2, 1, 2, 2, 2, 2, 2, 2, 1};

		for (int i = 1; i <= 16; i++) {
			C[i] = shift(C[i-1], shiftSize[i-1]);
			D[i] = shift(D[i-1], shiftSize[i-1]);
		}

		boolean[][] result = new boolean[16][48];
		for (int i = 0; i < 16; i++) {
			for (int j = 0; j < 48; j++) {
				int pc2Index = pc2[j]-1;
				if (pc2Index >= 28)
					result[i][j] = D[i+1][pc2Index-28];
				else
					result[i][j] = C[i+1][pc2Index];
			}
			System.out.println("K" + (i+1)); // display each subkey (temporarily, for verification)
			displayBits(result[i], 6);
		}

		return result;
	}

	// Perform a left bit shift on the given bits, wrapping bits at the start around to the end
	public static boolean[] shift(boolean[] subKeyHalf, int shiftSize) {
		boolean[] result = new boolean[subKeyHalf.length];

		for (int i = 0; i < result.length; i++) {
			result[i] = subKeyHalf[(i + shiftSize) % subKeyHalf.length];
		}

		return result;
	}

	// Display an array of bits, grouped with the specified group size
	public static void displayBits(boolean[] bits, int groupSize) {
		for (int i = 0; i < bits.length; i++) {
			System.out.print(bits[i] ? '1' : '0');
			if (i % groupSize == groupSize - 1)
				System.out.print(" ");
		}
		System.out.println();
	}

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
