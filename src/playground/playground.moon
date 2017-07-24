class A
  new: (msg) =>
    print("this is" .. msg)

class B extends A
    new: (msg) =>
        super(msg)
        print("and also lol")


b = B("hello")
