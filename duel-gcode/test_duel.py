import unittest

from duel import offset_gcode_line

class OffsetTest(unittest.TestCase):
    def test_basic_g0(self):
        line = 'G0 X0.0 Y0.0'
        new_line = offset_gcode_line(line, 1, 2)
        self.assertEqual('G0 X1 Y2', new_line)

    def test_basic_g1(self):
        line = 'G1 X0.1 Y0'
        new_line = offset_gcode_line(line, 1, 2)
        self.assertEqual('G1 X1.1 Y2', new_line)

    def test_order_preserved(self):
        line = 'G1 Y0 X0'
        new_line = offset_gcode_line(line, 1, 2)
        self.assertEqual('G1 Y2 X1', new_line)

    def test_negative_sign_pos(self):
        line = 'G1 X0'
        new_line = offset_gcode_line(line, -1, 0)
        self.assertEqual('G1 X-1', new_line)
