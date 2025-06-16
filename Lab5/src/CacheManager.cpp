#include "CacheManager.h"
#include <math.h>

CacheManager::CacheManager(Memory *memory, Cache *cache){
    // TODO: implement your constructor here
    // TODO: set tag_bits accord to your design.
    // Hint: you can access cache size by cache->get_size();
    // Hint: you need to call cache->set_block_size();
    this->memory = memory;
    this->cache = cache;
    size = cache->get_size();
    cache->set_block_size(32);
    
    num_sets = cache->get_len() / ASSOCIATIVITY;
    
   
    unsigned int set_bits = log2(num_sets);
    tag_bits = 32 - set_bits - 5;
    
    
    lru_counters.resize(num_sets, std::vector<unsigned int>(ASSOCIATIVITY, 0));
    global_counter.resize(num_sets, 0);
}

CacheManager::~CacheManager(){

}

std::pair<unsigned, unsigned> CacheManager::directed_map(unsigned int addr){
    unsigned int set_bits = log2(num_sets);
    unsigned int set_index = (addr >> 5) % num_sets;  
    unsigned int tag = addr >> (set_bits + 5); 
    return {set_index, tag};
}

unsigned int* CacheManager::find(unsigned int addr){
    // TODO:: implement function determined addr is in cache or not
    // if addr is in cache, return target pointer, otherwise return nullptr.
    // you shouldn't access memory in this function.
    auto [set_index, tag] = directed_map(addr);
    
    
    for(int way = 0; way < ASSOCIATIVITY; way++){
        unsigned int cache_index = set_index * ASSOCIATIVITY + way;
        if(cache_index < cache->get_len() && (*cache)[cache_index].tag == tag){
            
            global_counter[set_index]++;
            lru_counters[set_index][way] = global_counter[set_index];
            
            
            unsigned int block_offset = (addr >> 2) & 0x7;
            return &((*cache)[cache_index][block_offset]);
        }
    }
    return nullptr;
}

unsigned int CacheManager::read(unsigned int addr){
    
    unsigned int* value_ptr = find(addr);
    if(value_ptr != nullptr){
        return *value_ptr;
    }
    else{
        
        auto [set_index, tag] = directed_map(addr);
        
        int lru_way = 0;
        unsigned int min_counter = lru_counters[set_index][0];
        
        for(int way = 1; way < ASSOCIATIVITY; way++){
            if(lru_counters[set_index][way] < min_counter){
                min_counter = lru_counters[set_index][way];
                lru_way = way;
            }
        }
        
        unsigned int cache_index = set_index * ASSOCIATIVITY + lru_way;
        if(cache_index < cache->get_len()){
            (*cache)[cache_index].tag = tag;
            
           
            unsigned int base_addr = addr & ~0x1F;
            for(int i = 0; i < 8; i++){
                unsigned int word_addr = base_addr + (i * 4);
                unsigned int value = memory->read(word_addr);
                (*cache)[cache_index][i] = value;
            }

            global_counter[set_index]++;
            lru_counters[set_index][lru_way] = global_counter[set_index];
            
            unsigned int block_offset = (addr >> 2) & 0x7;
            return (*cache)[cache_index][block_offset];
        }
        
        return memory->read(addr);
    }
}

void CacheManager::write(unsigned int addr, unsigned value){
    // TODO:: write value to addr
    auto [set_index, tag] = directed_map(addr);
    
    for(int way = 0; way < ASSOCIATIVITY; way++){
        unsigned int cache_index = set_index * ASSOCIATIVITY + way;
        if(cache_index < cache->get_len() && (*cache)[cache_index].tag == tag){
            unsigned int block_offset = (addr >> 2) & 0x7;
            (*cache)[cache_index][block_offset] = value;
            global_counter[set_index]++;
            lru_counters[set_index][way] = global_counter[set_index];
            break;
        }
    }
    memory->write(addr, value);
}
