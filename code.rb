EPS = 0.0001
x = gets()
y = x
n = 2
vs = x
until abs( vs) < EPS

  vs = - vs * x * x / (2 * n - 1) / (2 * n - 2)
  n = n + 1
  y = y + vs
  op()
  str = "kjoo"
  myTest()
  myTest()

end
puts( x , y , EPS , "qwerty" )

def op
  v = 5 + p
end

def myTest
  test = 6
end