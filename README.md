#                                                 MIPS-Programming-Assignment-2 #
This MIPS program gets input from the user. The input, which is a string, is then divided into sub-strings. Partitioning is done when comma is found in the input. Then, the substring is converted into unsiged decimal value if it is a hexadecimal string. Otherwise, it iwll show an error message. Output is show is shown in the same way input was given.
# Characteristics #
* The program can read up to 1000 characters from user input.
* Spaces or tabs at the beginning or end or around commas are ignored.
* Commas or tabs found inside substrings are considered invalid ("123  456")
* Program prints out the string of "too large" if the substring has more than 8 characters.
* Empty strings before the first comma, between commas or after the last comma are also considered "NaN"
