return {
  version = "1.2",
  luaversion = "5.1",
  tiledversion = "1.3.2",
  orientation = "orthogonal",
  renderorder = "right-down",
  width = 37,
  height = 20,
  tilewidth = 128,
  tileheight = 128,
  nextlayerid = 19,
  nextobjectid = 85,
  properties = {},
  tilesets = {
    {
      name = "Tiles_Spaceship",
      firstgid = 1,
      filename = "../TileSets/Tiles_Spaceship.tsx",
      tilewidth = 128,
      tileheight = 128,
      spacing = 0,
      margin = 0,
      columns = 10,
      image = "../TileSets/Tiles_Spaceship.png",
      imagewidth = 1280,
      imageheight = 1280,
      tileoffset = {
        x = 0,
        y = 0
      },
      grid = {
        orientation = "orthogonal",
        width = 128,
        height = 128
      },
      properties = {},
      terrains = {},
      tilecount = 100,
      tiles = {}
    }
  },
  layers = {
    {
      type = "tilelayer",
      id = 2,
      name = "walls",
      x = 0,
      y = 0,
      width = 37,
      height = 20,
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      properties = {},
      encoding = "lua",
      data = {
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8, 8, 8, 8, 8, 8, 8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8, 8, 8, 8, 8, 8, 8, 8, 8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 0, 0, 0, 0, 0, 0,
        0, 0, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 0, 0, 0, 0, 0, 0,
        0, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 0, 0, 0, 0, 0, 0,
        8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 0, 0, 0,
        8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 0, 0,
        8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 0,
        0, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 0,
        0, 0, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 0, 0,
        0, 0, 0, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8, 8, 8, 8, 8, 8, 8, 8, 8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
      }
    },
    {
      type = "imagelayer",
      id = 5,
      name = "trash",
      visible = true,
      opacity = 1,
      offsetx = 1464.24,
      offsety = 1928.61,
      image = "../Images/Trash_Asset.png",
      properties = {}
    },
    {
      type = "imagelayer",
      id = 15,
      name = "engines",
      visible = true,
      opacity = 1,
      offsetx = 228,
      offsety = 1052,
      image = "../Images/Engine_Asset.png",
      properties = {}
    },
    {
      type = "imagelayer",
      id = 16,
      name = "weapons",
      visible = true,
      opacity = 1,
      offsetx = 3456,
      offsety = 512,
      image = "../Images/Weapon_Asset.png",
      properties = {}
    },
    {
      type = "imagelayer",
      id = 17,
      name = "cockpit",
      visible = true,
      opacity = 1,
      offsetx = 4096,
      offsety = 1280,
      image = "../Images/Cockpit_Asset.png",
      properties = {}
    },
    {
      type = "imagelayer",
      id = 14,
      name = "shields",
      visible = true,
      opacity = 1,
      offsetx = 1920,
      offsety = 384,
      image = "../Images/Shield_Asset.png",
      properties = {}
    },
    {
      type = "tilelayer",
      id = 18,
      name = "decoration",
      x = 0,
      y = 0,
      width = 37,
      height = 20,
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      properties = {},
      encoding = "lua",
      data = {
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 55, 52, 52, 52, 52, 52, 54, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 55, 54, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 60, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 46, 47, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 55, 52, 52, 52, 52, 52, 54, 0, 0, 0, 0, 70, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 56, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 2147483697, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 3221225511, 0, 0, 0, 0, 0, 0, 46, 47, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 45, 0, 0, 0, 0, 0, 0, 56, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 40, 0, 0, 0, 1073741866, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 33, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 50, 0, 0, 0, 1073741856, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2147483692, 44, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 43, 44, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 51, 52, 52, 52, 52, 52, 52, 52, 52, 52, 53, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2684354565, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2147483681, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
      }
    },
    {
      type = "tilelayer",
      id = 1,
      name = "floors",
      x = 0,
      y = 0,
      width = 37,
      height = 20,
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      properties = {},
      encoding = "lua",
      data = {
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2684354563, 1, 1, 1, 1, 1, 1, 1, 3221225475, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2684354563, 1, 0, 0, 0, 0, 0, 0, 0, 1, 3221225475, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2684354561, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 3221225475, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2684354561, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2684354561, 0, 0, 2684354561, 0, 0, 0, 0, 0, 1, 3221225475, 0, 0, 0, 0, 0, 0,
        0, 0, 2684354563, 1, 1, 1, 1, 1, 1, 1, 2684354561, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2684354561, 0, 0, 2684354561, 0, 0, 0, 0, 0, 0, 2684354561, 0, 0, 0, 0, 0, 0,
        0, 2684354563, 1, 0, 0, 0, 0, 0, 0, 0, 2684354561, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2684354561, 0, 0, 11, 0, 0, 0, 0, 0, 0, 2684354561, 0, 0, 0, 0, 0, 0,
        2684354563, 1, 0, 0, 0, 0, 0, 0, 0, 0, 2684354561, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2684354561, 0, 0, 21, 0, 0, 0, 0, 0, 0, 2684354561, 0, 0, 0, 0, 0, 0,
        2684354561, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2684354561, 9, 1610612743, 1610612743, 1610612743, 1610612743, 1610612743, 1610612743, 1610612743, 1610612743, 1610612743, 9, 1610612743, 1610612743, 1610612743, 1610612743, 1610612743, 1610612743, 1610612743, 1610612743, 2684354567, 2684354567, 2684354567, 2684354567, 3221225475, 0, 0,
        2684354561, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2684354561, 9, 0, 0, 0, 0, 0, 0, 0, 0, 0, 9, 0, 0, 0, 0, 2684354561, 0, 0, 0, 0, 0, 0, 0, 1, 3221225475, 0,
        2684354561, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2684354561, 9, 0, 0, 0, 0, 0, 0, 0, 0, 0, 9, 0, 0, 0, 0, 2684354561, 0, 0, 0, 0, 0, 0, 0, 0, 2684354561, 0,
        3, 1, 0, 0, 0, 0, 0, 0, 0, 0, 11, 9, 0, 0, 0, 0, 0, 0, 0, 0, 0, 9, 0, 0, 0, 0, 11, 0, 0, 0, 0, 0, 0, 0, 0, 2684354561, 0,
        0, 3, 1, 0, 0, 0, 0, 0, 0, 0, 21, 9, 0, 0, 0, 0, 0, 0, 0, 0, 0, 9, 0, 0, 0, 0, 21, 0, 0, 0, 0, 0, 0, 0, 1, 1610612739, 0,
        0, 0, 3, 2684354567, 2684354567, 2684354567, 2684354567, 9, 1610612743, 1610612743, 1610612743, 1610612743, 1610612743, 1610612743, 1610612743, 1610612743, 1610612743, 1610612743, 1610612743, 1610612743, 1610612743, 1610612743, 1610612743, 1610612743, 1610612743, 9, 2684354567, 2684354567, 2684354567, 2684354567, 2684354567, 2684354567, 2684354567, 2684354567, 1610612739, 0, 0,
        0, 0, 0, 0, 0, 0, 2684354561, 9, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 9, 2684354561, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 2684354561, 9, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 9, 2684354561, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 2684354561, 9, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 9, 2684354561, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 3, 2684354567, 2684354567, 2684354567, 2684354567, 2684354567, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2684354567, 2684354567, 2684354567, 2684354567, 2684354567, 1610612739, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2684354561, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2684354561, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2684354561, 45, 0, 0, 0, 0, 0, 0, 0, 2147483693, 2684354561, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3, 2684354567, 2684354567, 2684354567, 2684354567, 2684354567, 2684354567, 2684354567, 2684354567, 2684354567, 1610612739, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
      }
    },
    {
      type = "objectgroup",
      id = 13,
      name = "Walls",
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      draworder = "topdown",
      properties = {},
      objects = {
        {
          id = 51,
          name = "",
          type = "",
          shape = "rectangle",
          x = 384,
          y = 512,
          width = 896,
          height = 128,
          rotation = 0,
          visible = true,
          properties = {
            ["collidable"] = true
          }
        },
        {
          id = 52,
          name = "",
          type = "",
          shape = "rectangle",
          x = 1280,
          y = 256,
          width = 128,
          height = 1024,
          rotation = 0,
          visible = true,
          properties = {
            ["collidable"] = true
          }
        },
        {
          id = 53,
          name = "",
          type = "",
          shape = "rectangle",
          x = 1536,
          y = 0,
          width = 896,
          height = 128,
          rotation = 0,
          visible = true,
          properties = {
            ["collidable"] = true
          }
        },
        {
          id = 54,
          name = "",
          type = "",
          shape = "rectangle",
          x = 2560,
          y = 256,
          width = 128,
          height = 768,
          rotation = 0,
          visible = true,
          properties = {
            ["collidable"] = true
          }
        },
        {
          id = 55,
          name = "",
          type = "",
          shape = "rectangle",
          x = 1536,
          y = 896,
          width = 1024,
          height = 128,
          rotation = 0,
          visible = true,
          properties = {
            ["collidable"] = true
          }
        },
        {
          id = 56,
          name = "",
          type = "",
          shape = "rectangle",
          x = 0,
          y = 896,
          width = 128,
          height = 384,
          rotation = 0,
          visible = true,
          properties = {
            ["collidable"] = true
          }
        },
        {
          id = 57,
          name = "",
          type = "",
          shape = "polygon",
          x = 384,
          y = 512,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          polygon = {
            { x = 0, y = 0 },
            { x = 0, y = 128 },
            { x = -256, y = 384 },
            { x = -384, y = 384 }
          },
          properties = {
            ["collidable"] = true
          }
        },
        {
          id = 58,
          name = "",
          type = "",
          shape = "polygon",
          x = 0,
          y = 1280,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          polygon = {
            { x = 0, y = 0 },
            { x = 256, y = 0 },
            { x = 256, y = 128 },
            { x = 384, y = 128 },
            { x = 384, y = 384 }
          },
          properties = {
            ["collidable"] = true
          }
        },
        {
          id = 60,
          name = "",
          type = "",
          shape = "rectangle",
          x = 384,
          y = 1536,
          width = 512,
          height = 128,
          rotation = 0,
          visible = true,
          properties = {
            ["collidable"] = true
          }
        },
        {
          id = 61,
          name = "",
          type = "",
          shape = "rectangle",
          x = 768,
          y = 1664,
          width = 128,
          height = 384,
          rotation = 0,
          visible = true,
          properties = {
            ["collidable"] = true
          }
        },
        {
          id = 63,
          name = "",
          type = "",
          shape = "rectangle",
          x = 768,
          y = 2048,
          width = 768,
          height = 128,
          rotation = 0,
          visible = true,
          properties = {
            ["collidable"] = true
          }
        },
        {
          id = 64,
          name = "",
          type = "",
          shape = "rectangle",
          x = 1408,
          y = 2176,
          width = 128,
          height = 384,
          rotation = 0,
          visible = true,
          properties = {
            ["collidable"] = true
          }
        },
        {
          id = 65,
          name = "",
          type = "",
          shape = "rectangle",
          x = 1536,
          y = 2432,
          width = 1280,
          height = 128,
          rotation = 0,
          visible = true,
          properties = {
            ["collidable"] = true
          }
        },
        {
          id = 66,
          name = "",
          type = "",
          shape = "rectangle",
          x = 2688,
          y = 2048,
          width = 128,
          height = 384,
          rotation = 0,
          visible = true,
          properties = {
            ["collidable"] = true
          }
        },
        {
          id = 67,
          name = "",
          type = "",
          shape = "rectangle",
          x = 2816,
          y = 2048,
          width = 640,
          height = 128,
          rotation = 0,
          visible = true,
          properties = {
            ["collidable"] = true
          }
        },
        {
          id = 68,
          name = "",
          type = "",
          shape = "rectangle",
          x = 3328,
          y = 1536,
          width = 128,
          height = 512,
          rotation = 0,
          visible = true,
          properties = {
            ["collidable"] = true
          }
        },
        {
          id = 69,
          name = "",
          type = "",
          shape = "rectangle",
          x = 1024,
          y = 1536,
          width = 2176,
          height = 128,
          rotation = 0,
          visible = true,
          properties = {
            ["collidable"] = true
          }
        },
        {
          id = 70,
          name = "",
          type = "",
          shape = "rectangle",
          x = 3456,
          y = 1536,
          width = 1024,
          height = 128,
          rotation = 0,
          visible = true,
          properties = {
            ["collidable"] = true
          }
        },
        {
          id = 71,
          name = "",
          type = "",
          shape = "rectangle",
          x = 4352,
          y = 896,
          width = 256,
          height = 640,
          rotation = 0,
          visible = true,
          properties = {
            ["collidable"] = true
          }
        },
        {
          id = 72,
          name = "",
          type = "",
          shape = "rectangle",
          x = 2816,
          y = 896,
          width = 1536,
          height = 128,
          rotation = 0,
          visible = true,
          properties = {
            ["collidable"] = true
          }
        },
        {
          id = 73,
          name = "",
          type = "",
          shape = "rectangle",
          x = 3328,
          y = 1024,
          width = 128,
          height = 256,
          rotation = 0,
          visible = true,
          properties = {
            ["collidable"] = true
          }
        },
        {
          id = 74,
          name = "",
          type = "",
          shape = "rectangle",
          x = 3840,
          y = 384,
          width = 128,
          height = 512,
          rotation = 0,
          visible = true,
          properties = {
            ["collidable"] = true
          }
        },
        {
          id = 75,
          name = "",
          type = "",
          shape = "rectangle",
          x = 2688,
          y = 256,
          width = 1152,
          height = 128,
          rotation = 0,
          visible = true,
          properties = {
            ["collidable"] = true
          }
        },
        {
          id = 76,
          name = "",
          type = "",
          shape = "rectangle",
          x = 3712,
          y = 384,
          width = 128,
          height = 128,
          rotation = 0,
          visible = true,
          properties = {
            ["collidable"] = true
          }
        },
        {
          id = 77,
          name = "",
          type = "",
          shape = "rectangle",
          x = 2432,
          y = 0,
          width = 256,
          height = 256,
          rotation = 0,
          visible = true,
          properties = {
            ["collidable"] = true
          }
        },
        {
          id = 78,
          name = "",
          type = "",
          shape = "rectangle",
          x = 1280,
          y = 0,
          width = 256,
          height = 256,
          rotation = 0,
          visible = true,
          properties = {
            ["collidable"] = true
          }
        },
        {
          id = 79,
          name = "",
          type = "",
          shape = "rectangle",
          x = 2944,
          y = 384,
          width = 128,
          height = 256,
          rotation = 0,
          visible = true,
          properties = {
            ["collidable"] = true
          }
        },
        {
          id = 82,
          name = "",
          type = "",
          shape = "polygon",
          x = 1536,
          y = 2048,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          polygon = {
            { x = 0, y = 0 },
            { x = 0, y = 256 },
            { x = 1152, y = 256 },
            { x = 1152, y = 0 },
            { x = 1024, y = 128 },
            { x = 888, y = 32 },
            { x = 582, y = -34 },
            { x = 428, y = -30 },
            { x = 138, y = 132 }
          },
          properties = {
            ["collidable"] = true
          }
        }
      }
    },
    {
      type = "objectgroup",
      id = 12,
      name = "Objects",
      visible = false,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      draworder = "topdown",
      properties = {},
      objects = {
        {
          id = 39,
          name = "",
          type = "",
          shape = "rectangle",
          x = 256,
          y = 1152,
          width = 640,
          height = 384,
          rotation = 0,
          visible = true,
          properties = {
            ["collidable"] = true,
            ["sensor"] = true,
            ["type"] = "engines"
          }
        },
        {
          id = 47,
          name = "",
          type = "",
          shape = "rectangle",
          x = 1920,
          y = 512,
          width = 640,
          height = 384,
          rotation = 0,
          visible = true,
          properties = {
            ["collidable"] = true,
            ["sensor"] = true,
            ["type"] = "shields"
          }
        },
        {
          id = 48,
          name = "",
          type = "",
          shape = "rectangle",
          x = 3584,
          y = 384,
          width = 256,
          height = 512,
          rotation = 0,
          visible = true,
          properties = {
            ["collidable"] = true,
            ["sensor"] = true,
            ["type"] = "weapons"
          }
        },
        {
          id = 49,
          name = "",
          type = "",
          shape = "rectangle",
          x = 4096,
          y = 1280,
          width = 256,
          height = 256,
          rotation = 0,
          visible = true,
          properties = {
            ["collidable"] = true,
            ["sensor"] = true,
            ["type"] = "cockpit"
          }
        },
        {
          id = 83,
          name = "",
          type = "",
          shape = "rectangle",
          x = 1536,
          y = 1792,
          width = 1152,
          height = 512,
          rotation = 0,
          visible = true,
          properties = {
            ["collidable"] = true,
            ["sensor"] = true,
            ["type"] = "junk"
          }
        },
        {
          id = 84,
          name = "",
          type = "",
          shape = "polygon",
          x = 1542,
          y = 2008,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          polygon = {
            { x = 14, y = 138 },
            { x = 596, y = 560 },
            { x = 1126, y = 110 },
            { x = 1028, y = 124 },
            { x = 888, y = 32 },
            { x = 582, y = -34 },
            { x = 428, y = -30 },
            { x = 138, y = 116 }
          },
          properties = {
            ["collidable"] = true,
            ["sensor"] = true,
            ["type"] = "junkkill"
          }
        }
      }
    },
    {
      type = "objectgroup",
      id = 11,
      name = "Ladders",
      visible = false,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      draworder = "topdown",
      properties = {},
      objects = {
        {
          id = 33,
          name = "",
          type = "",
          shape = "rectangle",
          x = 896,
          y = 1536,
          width = 128,
          height = 512,
          rotation = 0,
          visible = true,
          properties = {
            ["collidable"] = true,
            ["sensor"] = true,
            ["type"] = "ladder"
          }
        },
        {
          id = 34,
          name = "",
          type = "",
          shape = "rectangle",
          x = 1408,
          y = 896,
          width = 128,
          height = 640,
          rotation = 0,
          visible = true,
          properties = {
            ["collidable"] = true,
            ["sensor"] = true,
            ["type"] = "ladder"
          }
        },
        {
          id = 35,
          name = "",
          type = "",
          shape = "rectangle",
          x = 2688,
          y = 896,
          width = 128,
          height = 640,
          rotation = 0,
          visible = true,
          properties = {
            ["collidable"] = true,
            ["sensor"] = true,
            ["type"] = "ladder"
          }
        },
        {
          id = 36,
          name = "",
          type = "",
          shape = "rectangle",
          x = 3200,
          y = 1536,
          width = 128,
          height = 512,
          rotation = 0,
          visible = true,
          properties = {
            ["collidable"] = true,
            ["sensor"] = true,
            ["type"] = "ladder"
          }
        }
      }
    }
  }
}
