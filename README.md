This design is a Carry Looked Ahead (CLA) Adder with flexibility Width.
I design 5 module is: Full Adder, CLA 2 bit, CLA 3 bit, CLA 4 bit and module top adder_flex.
The quotient of Width/4 is the number of CLA 4 bit are used. Example: Width = 12 that is 4 module CLA 4 bit are used.
The remainder of Width/4 is the final Adder is used. Full Adder for readmainder = 1, CLA 2 bit for remainder = 2, CLA 3 bit for remainder = 3, remainder = 0 that is no module is used.
EX: Width = 19 - 4 module CLA 4 bit and 1 module CLA 3 bit is use to create a Adder Flexibility Width.
