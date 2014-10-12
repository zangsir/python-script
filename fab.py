table = {}
def fib(n):
    print "--------------"
    print "first:n=",n
    global table
    if table.has_key(n):
        print "table has key:return ",n,"is",table[n]
        return table[n]
    print table
    if n == 0 or n == 1:
        table[n] = n
        print "******"
        print "(second) return:",n,"=",n
        return n
    else:
        value = fib(n-1) + fib(n-2)
        table[n] = value
        print "%%%%%%"
        print "(third) return n is[",n,"]=",value
        print table,"(last)"
        return value