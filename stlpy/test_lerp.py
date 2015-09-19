import stl
import unittest

class TestLerp(unittest.TestCase):
    def test_lerp(self):
        self.assertEqual(stl.lerp(0, 10, 0.5), 5)

    def test_lerp2(self):
        self.assertEqual(stl.lerp2(0, 10, 2, 6, 0), 2)
        self.assertEqual(stl.lerp2(0, 10, 2, 6, 10), 6)
        self.assertEqual(stl.lerp2(0, 10, 2, 6, 5), 4)
