# ECE287_Project

Project:
We propose a project to implement DES encryption / decryption using an FPGA.
The encryption device will take 64 bits of data. Initially, the algorithm will be
tested using a protocol of inputting byte-by-byte with the board’s built-in
switches. The output (encrypted bits) can then be displayed in hexadecimal
format on the board’s display. If time allows, we may then develop an IO
mechanism for loading bits to and from the encryption device as files.

Input Type:
For our minimum viable product, the input will use only the board and no external
devices. 8 sliding switches will be used to input a byte of data, and then a push
button will confirm the byte and prepare for the next byte’s entry. After 8 bytes are
entered, the algorithm has all input data needed to run. If time allows after this
version is working, the encryption device may instead receive input -- encrypted
or plaintext -- from an external device. This will be converted into binary so the
FPGA board can read the data. For the I/O operations, we will consider the
board’s Ethernet or USB connections for this more advanced input.
	
Output:
There will be two different output choices. Firstly, we will display the encrypted
data for proof of completion - the board’s display has two 16-character lines,
which is just enough to show the 64-bit input and the 64-bit output in
hexadecimal format. Later, if we are able to interface with an external device to
output data, the display screen may instead show relevant information, such as
the key that the algorithm is using for encryption / decryption.
