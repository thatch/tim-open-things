# Must feature 3n+1 points:
#   fixed, (control, control, fixed)+
# Use of X says "mirror previous control point"
$steps=20
cubicspline([[-10,0], [-10, 5], [0, 5], [0, 0], None, [10, -5], [10, 0]])
[[10,-10]]
[[-10,-10]]
