# sequential to parallel C code convertor

## Description
This tool converts a <ins>sequential</ins> C code in input, to a <ins>parallel</ins> C code as output.

It achieves  **Task parallelism (<ins>only</ins>)**.



**NOTES** : 
* "seq.c" is the sequential code to convert and needs to be written in a specefic format (See "Preparation" section below)
* This convertor uses @iamsubhranil 's C [ThreadPool](https://github.com/iamsubhranil/ThreadPool), thus it is **mandatory** for the functionnality of this convertor.
* gcc was used as compiler
* gprof is used to proritize some tasks before others depending on their execution time. Shorter ones are being prioritized when first put in the pool.

## Installation

1.  Start by cloning this repository :
```bash
git clone https://github.com/Sko-P/semi-automatic
```
2. Clone @iamsubhranil 's C [ThreadPool](https://github.com/iamsubhranil/ThreadPool) :
```bash
git clone https://github.com/iamsubhranil/ThreadPool
```
3. Install [gprof](https://www.howtoforge.com/tutorial/how-to-install-and-use-profiling-tool-gprof/)

## Preparation
As stated above, this converter achieves **Task parallelism**, and your code needs to be written in a specefic format, which is the following :
```C
int function1(int a)
{
    //operations that function1 performs

    return x;
}

void function2(float *c, int *n)
{
    //operations that function2 performs
}

/*
Other functions/methods ...
*/

int main()
{
    //Calling the functions and putting a specefic comment before their call
    int a = 5
    int x;

    //#function1 a x
    x = function1(a)
    
    float b = 4
    //#function2 b,c /  
    function2(&b,&c)
}
```  
This converter parallelizes **Tasks** executions depending on their input/output.

A dependency tree is built in the back-end and used to write the parallel version. 

The comment used before the functions' call in the main needs to be of the following format :  
```C
//#function_name inputs outputs
```
Multiple inputs and outputs needs to be seperated by a comma (',') like shown in the format above.

Empty inputs or outputs have to be stated in the special comment with a "/".  

Exemple :

```C
//#print_values a,b /
print_values(a,b)
```
In this exemple, the function *print_values* takes *a* and *b* as inputs, and has no output.



## Usage
1. Rename your sequential program to "seq.c" and put it with this converter's files
2. Open terminal in the repository folder, and execute this command :  
```bash
chmod +x essai.sh
```
3. Execute the following command in the terminal :
```bash
./essai.sh
```
The parallel version of your program should appear named, "para.c" within the folder you are working on.

## Propositions
* Feel free to raise an issue.
* Contact the contributors
