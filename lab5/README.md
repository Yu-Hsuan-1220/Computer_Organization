# Implement Cache Manager

## Introduction
This lab you'll design a cache manager to manage the cache table and data in cache, also make sure your data is correct in cache and memory.

We provide the code of cache simulator, but cache manager is empty, you need to implement the cache manager to finish lab.

The implementation method of the cache manager has no restrictions, and there are no specified block size requirements. 
As long as the cache operates correctly, both **Direct Mapped** and **Set Associative Cache** are acceptable. 
Additionally, you are free to design the **Cache replacement policy** and **update policy** as you see fit.

 

## Explain the code
```cpp
class Cache
{
private:
    std::vector<Block> blocks;
    const unsigned int size;
    unsigned int len;
public:
    Cache(unsigned int size);   
    
    unsigned int get_size();
    unsigned int get_len();
    unsigned int set_block_size(unsigned int block_size);
    unsigned int get_machine_address_bit();
    
    Block& operator[](unsigned int index);
};
```
This is the Class of **Cache** we provide, you can use the
```get_size()```  get size of cache.
```get_len()```  get number of block.
```set_block_size(unsigned int block_size)```  set block size by yourself, This configuration will be related to the number of cache lines.
```get_machine_address_bit()``` get machine address base.

-----

```cpp
class Block{
private:
    std::vector<unsigned int> values;
public:
    unsigned int len;
    unsigned int tag;
    
    Block(unsigned int block_size);

    unsigned int& operator[](unsigned int index);
};
```
this is the Class of **Block** we provide, you must record the **Tag** in ```Block.tag``` when the data in cache, and you also can use the ```Block.len``` get how many word(4 bytes) in a block

-----

```cpp
class CacheManager
{
private:
    Memory *memory;
    Cache *cache;
    unsigned int size;       // bytes
    unsigned int tag_bits;
public:

    CacheManager(Memory *memory, Cache *cache);
    ~CacheManager();
    unsigned int read(unsigned int addr);
    void write(unsigned int addr, unsigned value);
};
```
This is Class of **CacheManager**, you need to config your metadata in Constructor (ex: block size, cache way...), and design your cache manager read/write in cpp file.
Test pattern will call the CacheManger read/write to communicate with your cache, so this part you must manage your data in cache and memory properly.


:bulb: block size need to call Class Cache api ```set_block_size(unsigned int block_size)```


#### simple test case
```
w bf880c18 83831c0a
w bf880c08 4a0c2c0e
w bf880c04 7446feef
r bf880c04
r bf880c08
w 80c9578 e79be23
r bf880c18
r 80c9578
```

:bulb: You can use Python to program the pattern generator to generate the test case to verify your Cache Manager

## Requirement
You can only modify CacheManager.cpp and CacheManager.h. For all who submit this lab, you will get 80 points if your miss counts is better than template, for the remained 20 points are based on the median miss counts of all submission.

Submit zip file with the following format.
```
<stduent_id>.zip
   |- <student_id>/
      |- CacheManager.cpp
      |- CacheManager.h
      |- (don't zip other files)
```

## Reference
Computer Organization and Design RISC-V Edition, CH5