/* DES encryption: Java Implementation
 * Authors: Jayson Rook and Zachary Zampa
 * Created: Fall 2018
 * Class: ECE 287
 * 
 * Extra Information:
 * Hardware is set for 64bits (8bytes) of data which means messages and keys are 16 hexadecimal digits
 */


public class DES_Encryption {

	// Main method: hard-code in keys, message, and encryption method to run automatically when executed
	public static void main(String[] args) {
		// Hard-code keys and message here
		boolean[] key1 = hex2bits("133457799bbcdff1", 64);
		boolean[] key2 = hex2bits("0000000000000000", 64);
		boolean[] message = hex2bits("0123456789abcdef", 64);
		
		// Choose between single and triple DES here
		//demoSingleDES(message, key1);
		demoTripleDES(message, key1, key2);
		
	} // end main method
	
	// Encrypt message with key, then show decrypted output matches original
	public static void demoSingleDES(boolean[] message, boolean[] key) {
		// Get subkeys
		boolean[][] subKeys = generateSubKeys(key);
		boolean[][] reversedSubKeys = new boolean[16][48];
		for (int i = 0; i < 16; i++) {
			reversedSubKeys[i] = subKeys[15-i];
		}
		
		System.out.println("Original:");
		displayHex(message);
		displayBits(message, 8);
		System.out.println();
		
		// Forward encrypt and display
		boolean[] encrypted = messageDES(message, subKeys);
		System.out.println("Single-DES Encrypted:");
		displayHex(encrypted);
		displayBits(encrypted, 8);
		System.out.println();
		
		// Decrypt and display
		boolean[] decrypted = messageDES(encrypted, reversedSubKeys);
		System.out.println("Decrypted:");
		displayHex(decrypted);
		displayBits(decrypted, 8);
		System.out.println();
	}
	
	// Triple DES-encrypt message with key1 and key2, then show decrypted output matches original
	public static void demoTripleDES(boolean[] message, boolean[] key1, boolean[] key2) {
		// Get subkeys
		boolean[][] subKeys1 = generateSubKeys(key1);
		boolean[][] reversedSubKeys1 = new boolean[16][48];
		for (int i = 0; i < 16; i++) {
			reversedSubKeys1[i] = subKeys1[15-i];
		}
		boolean[][] subKeys2 = generateSubKeys(key2);
		boolean[][] reversedSubKeys2 = new boolean[16][48];
		for (int i = 0; i < 16; i++) {
			reversedSubKeys2[i] = subKeys2[15-i];
		}
		
		System.out.println("Original:");
		displayHex(message);
		displayBits(message, 8);
		System.out.println();
		
		// Forward encrypt and display
		boolean[] encrypted = messageDES(message, subKeys1);
		encrypted = messageDES(encrypted, reversedSubKeys2);
		encrypted = messageDES(encrypted, subKeys1);
		System.out.println("Triple-DES Encrypted:");
		displayHex(encrypted);
		displayBits(encrypted, 8);
		System.out.println();
		
		// Decrypt and display
		boolean[] decrypted = messageDES(encrypted, reversedSubKeys1);
		decrypted = messageDES(decrypted, subKeys2);
		decrypted = messageDES(decrypted, reversedSubKeys1);
		System.out.println("Decrypted:");
		displayHex(decrypted);
		displayBits(decrypted, 8);
		System.out.println();
	}

	// ======================= Lookup tables for permutations =============================== 
	
	// Permuted choice lookup tables
	public static final int[] pc1 = new int[] {57, 49, 41, 33, 25, 17, 9, 
			1, 58, 50, 42, 34, 26, 18, 
			10, 2, 59, 51, 43, 35, 27, 
			19, 11, 3, 60, 52, 44, 36, 
			63, 55, 47, 39, 31, 23, 15, 
			7, 62, 54, 46, 38, 30, 22, 
			14, 6, 61, 53, 45, 37, 29, 
			21, 13, 5, 28, 20, 12, 4};

	public static final int[] pc2 = new int[] {14, 17, 11, 24, 1, 5, 3, 
			28, 15, 6, 21, 10, 23, 19, 
			12, 4, 26, 8, 16, 7, 27, 
			20, 13, 2, 41, 52, 31, 37, 
			47, 55, 30, 40, 51, 45, 33, 
			48, 44, 49, 39, 56, 34, 53, 
			46, 42, 50, 36, 29, 32};
	
	public static final int[] initialpermute = new int[] {58, 50, 42, 34, 26, 18, 10, 2, 
			60, 52, 44, 36, 28, 20, 12, 4, 
			62, 54, 46, 38, 30, 22, 14, 6, 
			64, 56, 48, 40, 32, 24, 16, 8, 
			57, 49, 41, 33, 25, 17, 9, 1, 
			59, 51, 43, 35, 27, 19, 11, 3, 
			61, 53, 45, 37, 29, 21, 13, 5, 
			63, 55, 47, 39, 31, 23, 15, 7};
	
	public static final int[] finalpermute = new int[] {40, 8, 48, 16, 56, 24, 64, 32, 
			39, 7, 47, 15, 55, 23, 63, 31, 
			38, 6, 46, 14, 54, 22, 62, 30, 
			37, 5, 45, 13, 53, 21, 61, 29, 
			36, 4, 44, 12, 52, 20, 60, 28, 
			35, 3, 43, 11, 51, 19, 59, 27, 
			34, 2, 42, 10, 50, 18, 58, 26, 
			33, 1, 41, 9, 49, 17, 57, 25,};
	
	public static final int[] exPermute = new int[] { 32, 1, 2, 3, 4, 5, 
			4, 5, 6, 7, 8, 9, 
			8, 9, 10, 11, 12, 13, 
			12, 13, 14, 15, 16, 17, 
			16, 17, 18, 19, 20, 21, 
			20, 21, 22, 23, 24, 25, 
			24, 25, 26, 27, 28, 29, 
			28, 29, 30, 31, 32, 1};
	
	public static final int[][] sBoxes = new int[][] {
		
		{14, 4, 13, 1, 2, 15, 11, 8, 3, 10, 6, 12, 5, 9, 0, 7, 
		0, 15, 7, 4, 14, 2, 13, 1, 10, 6, 12, 11, 9, 5, 3, 8, 
		4, 1, 14, 8, 13, 6, 2, 11, 15, 12, 9, 7, 3, 10, 5, 0, 
		15, 12, 8, 2, 4, 9, 1, 7, 5, 11, 3, 14, 10, 0, 6, 13}, // S1

		{15, 1, 8, 14, 6, 11, 3, 4, 9, 7, 2, 13, 12, 0, 5, 10, 
		3, 13, 4, 7, 15, 2, 8, 14, 12, 0, 1, 10, 6, 9, 11, 5, 
		0, 14, 7, 11, 10, 4, 13, 1, 5, 8, 12, 6, 9, 3, 2, 15, 
		13, 8, 10, 1, 3, 15, 4, 2, 11, 6, 7, 12, 0, 5, 14, 9}, // S2

		{10, 0, 9, 14, 6, 3, 15, 5, 1, 13, 12, 7, 11, 4, 2, 8, 
		13, 7, 0, 9, 3, 4, 6, 10, 2, 8, 5, 14, 12, 11, 15, 1, 
		13, 6, 4, 9, 8, 15, 3, 0, 11, 1, 2, 12, 5, 10, 14, 7, 
		1, 10, 13, 0, 6, 9, 8, 7, 4, 15, 14, 3, 11, 5, 2, 12},  // S3

		{7, 13, 14, 3, 0, 6, 9, 10, 1, 2, 8, 5, 11, 12, 4, 15, 
		13, 8, 11, 5, 6, 15, 0, 3, 4, 7, 2, 12, 1, 10, 14, 9, 
		10, 6, 9, 0, 12, 11, 7, 13, 15, 1, 3, 14, 5, 2, 8, 4, 
		3, 15, 0, 6, 10, 1, 13, 8, 9, 4, 5, 11, 12, 7, 2, 14}, // S4

		{2, 12, 4, 1, 7, 10, 11, 6, 8, 5, 3, 15, 13, 0, 14, 9, 
		14, 11, 2, 12, 4, 7, 13, 1, 5, 0, 15, 10, 3, 9, 8, 6, 
		4, 2, 1, 11, 10, 13, 7, 8, 15, 9, 12, 5, 6, 3, 0, 14, 
		11, 8, 12, 7, 1, 14, 2, 13, 6, 15, 0, 9, 10, 4, 5, 3}, // S5

		{12, 1, 10, 15, 9, 2, 6, 8, 0, 13, 3, 4, 14, 7, 5, 11, 
		10, 15, 4, 2, 7, 12, 9, 5, 6, 1, 13, 14, 0, 11, 3, 8, 
		9, 14, 15, 5, 2, 8, 12, 3, 7, 0, 4, 10, 1, 13, 11, 6, 
		4, 3, 2, 12, 9, 5, 15, 10, 11, 14, 1, 7, 6, 0, 8, 13}, // S6

		{4, 11, 2, 14, 15, 0, 8, 13, 3, 12, 9, 7, 5, 10, 6, 1, 
		13, 0, 11, 7, 4, 9, 1, 10, 14, 3, 5, 12, 2, 15, 8, 6, 
		1, 4, 11, 13, 12, 3, 7, 14, 10, 15, 6, 8, 0, 5, 9, 2, 
		6, 11, 13, 8, 1, 4, 10, 7, 9, 5, 0, 15, 14, 2, 3, 12}, // S7

		{13, 2, 8, 4, 6, 15, 11, 1, 10, 9, 3, 14, 5, 0, 12, 7, 
		1, 15, 13, 8, 10, 3, 7, 4, 12, 5, 6, 11, 0, 14, 9, 2, 
		7, 11, 4, 1, 9, 12, 14, 2, 0, 6, 10, 13, 15, 3, 5, 8, 
		2, 1, 14, 7, 4, 10, 8, 13, 15, 12, 9, 0, 3, 5, 6, 11} // S8
	};
	
	public static final int[] P = new int[] {16, 7, 20, 21, 
			29, 12, 28, 17, 
			1, 15, 23, 26, 
			5, 18, 31, 10, 
			2, 8, 24, 14, 
			32, 27, 3, 9, 
			19, 13, 30, 6, 
			22, 11, 4, 25};
	
	// =================================================================================

	// Given a 64-bit key, generate the 16 subkeys needed for the encryption algorithm
	public static boolean[][] generateSubKeys(boolean[] key) {
		// Initial permutation of the key
		boolean[] permutedKey = new boolean[56];
		for (int i = 0; i < 56; i++) {
			permutedKey[i] = key[pc1[i]-1];
		}

		// Split permuted key into halves C and D
		boolean[][] C = new boolean[17][28];
		boolean[][] D = new boolean[17][28];
		for (int i = 0; i < 28; i++) {
			C[0][i] = permutedKey[i];
			D[0][i] = permutedKey[i+28];
		}

		// Each C and D is a 1- or 2-position bit shift from the previous
		int[] shiftSize = new int[] {1, 1, 2, 2, 2, 2, 2, 2, 1, 2, 2, 2, 2, 2, 2, 1};
		for (int i = 1; i <= 16; i++) {
			C[i] = shift(C[i-1], shiftSize[i-1]);
			D[i] = shift(D[i-1], shiftSize[i-1]);
		}

		// Effectively concatenate C and D strings, and permute bits in each result using pc-2
		boolean[][] result = new boolean[16][48];
		for (int i = 0; i < 16; i++) {
			for (int j = 0; j < 48; j++) {
				int pc2Index = pc2[j]-1;
				if (pc2Index >= 28)
					result[i][j] = D[i+1][pc2Index-28];
				else
					result[i][j] = C[i+1][pc2Index];
			}
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

	// Display an array of bits, formatted as a hexadecimal string
	public static void displayHex(boolean[] bits) {
		int i = 0;
		while (i + 4 <= bits.length) {
			String digitStr = (bits[i] ? "1" : "0") + (bits[i+1] ? "1" : "0") + (bits[i+2] ? "1" : "0") + (bits[i+3] ? "1" : "0");
			System.out.print(Integer.toHexString(Integer.parseInt(digitStr, 2)));
			i += 4;
		}
		System.out.println();
	}
	
	// Convert a hexadecimal string hex into a bit array of length nBits
	public static boolean[] hex2bits(String hex, int nBits) {
		
		// Avoid potential overflow by breaking into 32-bit chunks
		if (nBits >= 64) {
			boolean[] result = new boolean[nBits];
			int chunk = 0;
			for (int i = 0; i < nBits - 1; i += 32) {
				int len = Math.min(32, nBits - chunk * 32);
				boolean[] tempBits = hex2bits(hex.substring(chunk * 8, chunk * 8 + (len / 4)), len);
				for (int j = 0; j < len; j++) {
					result[chunk * 32 + j] = tempBits[j];
				}
				chunk++;
			}
			return result;
		}
		
		// Create the array, padded properly at the start with zeros
		boolean[] bits = new boolean[nBits];
        String bitStr = Long.toString(Long.parseLong(hex.toLowerCase(), 16), 2);
        int bit = nBits - 1;
        for (int i = 0; i < bitStr.length(); i++) 
        {
                bits[bit] = bitStr.charAt(bitStr.length() - 1 - i) == '1';
                bit--;
        }
        return bits;
	}
	
	// modify original message then conduct rounds to encrypt
	public static boolean[] messageDES(boolean[] message, boolean[][] subkeys) {
            // permute the message
            boolean[] permutedMessage = new boolean[64];
            for (int i = 0; i < 64; i++) 
            {
                    permutedMessage[i] = message[initialpermute[i]-1];
            }
            
            // separate the message into two halves
            boolean[] left = new boolean[32];
            boolean[] right = new boolean[32];
            
            for (int i = 0; i < permutedMessage.length; i++)
            {
                if(i < 32)
                    left[i] = permutedMessage[i];
                else
                    right[i-32] = permutedMessage[i];
            }
            
            // The 16 encryption rounds, each invoking the f function with a different subkey
            for (int i = 0; i < 16; i++) {
            	boolean[] fOutput = f(right, subkeys[i]);
            	boolean[] temp = xorBits(left, fOutput);
            	left = right;
            	right = temp;
            }
            
            // Concatenate final left / right halves in reverse order
            boolean[] R16L16 = new boolean[64];
            for (int i = 0; i < 32; i++) {
            	R16L16[i] = right[i];
            	R16L16[i+32] = left[i];
            }
            
            // One last permutation before outputting
            boolean[] encryptedValue = new boolean[64];
            for (int i = 0; i < 64; i++) 
            {
                    encryptedValue[i] = R16L16[finalpermute[i]-1];
            }
            
            
            return encryptedValue;
            
	} // end messageDES method
	
	// Bitwise xor performed on equal-length boolean arrays
	public static boolean[] xorBits(boolean[] bits1, boolean[] bits2) {
		 boolean[] xorOperated = new boolean[bits1.length];
        for (int i = 0; i < xorOperated.length; i++)
        {
            xorOperated[i] = bits1[i] ^ bits2[i]; // can be changed to work for each iteration if needed
            
        }
        
        return xorOperated;
	}
	
	public static boolean[] f(boolean[] R, boolean[] K) {
		
		// make the expansion array: the right message half expands to 48 bits 
        boolean[] expanded = new boolean[48];
        for (int i = 0; i < 48; i++)
        {
            expanded[i] = R[exPermute[i]-1];
        }
        
        // XOR Operation between expanded right and corresponding round key
        boolean[] xorOperated = xorBits(expanded, K);
        
        boolean[] concatedSValues = new boolean[32];
        int concatedSValuesPosition = 0;
        
        // Collect new string of values by indexing s boxes
        for (int i = 0; i < 48; i += 6) {
        	int index = sBoxIndex(new boolean[] {xorOperated[i], xorOperated[i+1], xorOperated[i+2],
        			xorOperated[i+3], xorOperated[i+4], xorOperated[i+5]});
        	
        	int sVal = sBoxes[i/6][index];
        	
        	concatedSValues[concatedSValuesPosition] = sVal >= 8;
        	concatedSValues[concatedSValuesPosition + 1] = (sVal % 8) >= 4;
        	concatedSValues[concatedSValuesPosition + 2] = (sVal % 4) >= 2;
        	concatedSValues[concatedSValuesPosition + 3] = (sVal % 2) >= 1;
        	
        	concatedSValuesPosition += 4;
        	
        }
        
        // Permutation P, the last step of the f function
        
        boolean[] result = new boolean[32];
        for (int i = 0; i < 32; i++) 
        {
                result[i] = concatedSValues[P[i]-1];
        }
        
		return result; // result from f function
	}

	// Determines the 1-d index for an s box, based on the 6 identifying bits
	public static int sBoxIndex(boolean[] B) {
		return (B[0] ? 32 : 0)
				+ (B[1] ? 8 : 0)
				+ (B[2] ? 4 : 0)
				+ (B[3] ? 2 : 0)
				+ (B[4] ? 1 : 0)
				+ (B[5] ? 16 : 0);
	}
	
}
