In this project, we will use VHDL to design our own 32 bit MIPS processor by scratch. Once we compiled all the MIPS files into a Top Level VHDL file, we can compile the Top Level VHDL file in Quartus with a program in a included .mif file. Then we can program a Terasic DE10-Lite board to perform the operations of the .mif file.

<!-- TABLE OF CONTENTS -->
<details open="open">
  <summary>Table of Contents</summary>
  <ol>
    <li>
      <a href="#about-the-project">About The Project</a>
    </li>
    <li>
      <a href="#getting-started">Getting Started</a>
      <ul>
        <li><a href="#installation">Installation</a></li>
        <li><a href="#quartus">Quartus</a></li>
      </ul>
    </li>
    <li><a href="#usage">Usage</a></li>
    <li><a href="#authors">Authors</a></li>
  </ol>
</details>



<!-- ABOUT THE PROJECT -->
## About The Project

In this project we will be able to use VHDL to create our own 32 bit MIPS processor that will be able to run on a DE10-lite board.

![Screenshot](https://github.com/mlmulv/MIPS-32bit-VHDL/blob/main/MIPS%20Datapath.png)

<!-- GETTING STARTED -->
## Getting Started

To begin this project you will need to complete the following steps

### Installation

*  Clone the repo
   ```sh
   git clone https://github.com/mlmulv/MIPS-32bit-VHDL
   ```
### Quartus

1. Create Quartus Project
2. Go into On-Chip Memory and save the file as **blank_ram.vhd**. This is because the memory in the MIPS datapath is using the blank_ram file currently as it's memory.
3. Load in your **.mif** file you want to use.
4. Load in all the files into the quartus project **except the png images**.
5. Fully compile the files.
6. Connect your DE-10 Lite Board and program the board.

<!-- USAGE EXAMPLES -->
## Usage

1. We can now run a variety of different programs onto the board.
2. Within the files I provided, there is a **GCD.mif** and **bubble_sort.mif** file.
   *A. The **GCD.mif** file will output the greatest common denominator from two inputs. On the board you will use the 9 switches to input the two numbers you will use.
   *B. THE **bubble_sort.mif** file will not take inputs, but will output the bubble sort algorithm working on sorting an arrangment of different numbers.
3. You can use whichever mif file you provide.


<!-- Authors -->
## Authors

Markus Mulvihill - [LinkedIn](https://www.linkedin.com/in/markus-mulvihill-6549961a0/) - markusmulvihill1103@gmail.com

Project Link: (https://github.com/mlmulv/MIPS-32bit-VHDL)
