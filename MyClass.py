import sys

class MyClass(object):
    '''My Name is Soumya Ranjan Rout
    and this is my first class in philips'''
    def __init__(self,a,b):
        self.value1=a
        self.value2=b
    def exp(self):
        self.c=self.value1+self.value2
        self.d=self.value1*self.value2
        print "#"*20
        print "Valuse",self.c,self.d

    def soumya(self):
        self.exp()
        print "Inputs are",self.value1,self.value2
        print "#"*20

obj = MyClass(100,3)

print obj.soumya()

