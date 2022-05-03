-- Object A
-- 1.2 nodes tall
-- vertical to 45° right curve
-- 1-node width
--
--    .-^\
--   /    \
--  /    .-
--  |   -
--  |   |
--  +---+
--
------------------------------

-- line1 = outer_curve_points (starts at 0,0, ends at 0.646, 1.354)
-- line2 = inner_curve_points (starts at 1,0, ends at 1.354, 0.646)

-- 2d_2curve_closed(line1, line2)
-- export_mesh("a.obj")