This folder contains precomputed CRC32 values (using the reversed polynomial) for some Windows 32 bits DLLs function names (**taking into account the nullbyte!**).  
  
For quick lookups you can either grep this directory or use the executable "crc32" which takes the string as argument.  
  
The source of this file, crc32.asm, can be compiled using "compile_and_run.sh".  
  
Lastly, you can use "crc32_from_file.sh" to compute the CRC32 of different strings in the file given as argument.
