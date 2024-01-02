#!/usr/bin/env python
# coding: utf-8

# In[ ]:


import sys
data = sys.argv[1:]
print(data)
print(sum(list(map(int, data))))

