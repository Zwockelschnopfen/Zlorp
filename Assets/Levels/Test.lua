return {
  version = "1.2",
  luaversion = "5.1",
  tiledversion = "1.3.2",
  orientation = "orthogonal",
  renderorder = "right-down",
  width = 43,
  height = 20,
  tilewidth = 70,
  tileheight = 70,
  nextlayerid = 4,
  nextobjectid = 38,
  properties = {
    ["collider"] = true
  },
  tilesets = {
    {
      name = "sheet1",
      firstgid = 1,
      filename = "sheet1.tsx",
      tilewidth = 70,
      tileheight = 70,
      spacing = 0,
      margin = 0,
      columns = 14,
      image = "../TileSets/sheet.png",
      imagewidth = 980,
      imageheight = 490,
      tileoffset = {
        x = 0,
        y = 0
      },
      grid = {
        orientation = "orthogonal",
        width = 70,
        height = 70
      },
      properties = {},
      terrains = {},
      tilecount = 98,
      tiles = {}
    }
  },
  layers = {
    {
      type = "tilelayer",
      id = 1,
      name = "Tile Layer 1",
      x = 0,
      y = 0,
      width = 43,
      height = 20,
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      properties = {},
      encoding = "lua",
      data = {
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 536870933, 17, 17, 17, 17, 17, 2147483669, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 536870933, 3758096405, 0, 0, 0, 0, 0, 1073741845, 2147483669, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2147483668, 17, 17, 3758096405, 0, 0, 0, 0, 0, 0, 0, 1073741845, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 20, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 17, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 17, 0, 0, 17, 0, 0, 0, 0, 0, 9, 3221225492, 20, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 1610612756, 17, 17, 17, 17, 17, 17, 17, 17, 17, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 17, 0, 0, 17, 0, 0, 0, 0, 0, 9, 9, 17, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 1610612756, 2684354580, 0, 0, 0, 0, 0, 0, 0, 0, 17, 0, 0, 0, 0, 0, 12, 12, 12, 12, 12, 0, 17, 0, 0, 82, 0, 0, 0, 0, 0, 0, 9, 17, 0, 0, 0, 0, 0, 0, 0, 0,
        1610612756, 2684354580, 0, 0, 0, 0, 0, 0, 0, 0, 0, 17, 0, 0, 0, 0, 0, 12, 12, 12, 12, 12, 0, 17, 0, 0, 82, 0, 0, 0, 0, 9, 9, 9, 17, 0, 0, 0, 0, 0, 0, 0, 0,
        17, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 17, 46, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 46, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 2147483669, 0,
        17, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 17, 46, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 46, 0, 0, 0, 0, 0, 17, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1073741845, 2147483669,
        17, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 17, 46, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 46, 0, 0, 0, 0, 0, 17, 0, 0, 0, 0, 0, 0, 0, 0, 0, 83, 83, 17,
        1610612757, 2684354581, 0, 0, 0, 0, 0, 0, 0, 0, 0, 82, 46, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 46, 0, 0, 0, 0, 0, 82, 0, 0, 0, 0, 0, 0, 0, 0, 83, 83, 83, 17,
        0, 1610612757, 2684354581, 0, 0, 0, 0, 0, 0, 0, 0, 82, 46, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 46, 0, 0, 0, 0, 0, 82, 0, 0, 0, 0, 0, 0, 0, 0, 83, 83, 536870933, 3758096405,
        0, 0, 1610612757, 17, 17, 17, 17, 46, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 46, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 3758096405, 0,
        0, 0, 0, 0, 0, 0, 17, 46, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 46, 17, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 17, 46, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 46, 17, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 17, 46, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 46, 17, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 536870932, 17, 17, 17, 17, 17, 17, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 17, 17, 17, 17, 17, 17, 1073741844, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 17, 3221225525, 3221225526, 3221225526, 3221225526, 3221225526, 3221225526, 3221225526, 3221225526, 3221225526, 3221225526, 2684354613, 17, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 17, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 17, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 536870932, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 1073741844, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
      }
    },
    {
      type = "objectgroup",
      id = 2,
      name = "Walls",
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      draworder = "topdown",
      properties = {},
      objects = {
        {
          id = 1,
          name = "",
          type = "",
          shape = "rectangle",
          x = 910,
          y = 490,
          width = 770,
          height = 70,
          rotation = 0,
          visible = true,
          properties = {
            ["collidable"] = true
          }
        },
        {
          id = 2,
          name = "",
          type = "",
          shape = "rectangle",
          x = 560,
          y = 840,
          width = 1470,
          height = 70,
          rotation = 0,
          visible = true,
          properties = {
            ["collidable"] = true
          }
        },
        {
          id = 3,
          name = "",
          type = "",
          shape = "rectangle",
          x = 1750,
          y = 490,
          width = 1186.67,
          height = 70,
          rotation = 0,
          visible = true,
          properties = {
            ["collidable"] = true
          }
        },
        {
          id = 4,
          name = "",
          type = "",
          shape = "rectangle",
          x = 770,
          y = 140,
          width = 70,
          height = 560,
          rotation = 0,
          visible = true,
          properties = {
            ["collidable"] = true
          }
        },
        {
          id = 6,
          name = "",
          type = "",
          shape = "rectangle",
          x = 770,
          y = 138,
          width = 210,
          height = 70,
          rotation = 0,
          visible = true,
          properties = {
            ["collidable"] = true
          }
        },
        {
          id = 8,
          name = "",
          type = "",
          shape = "rectangle",
          x = 140,
          y = 280,
          width = 700,
          height = 70,
          rotation = 0,
          visible = true,
          properties = {
            ["collidable"] = true
          }
        },
        {
          id = 9,
          name = "",
          type = "",
          shape = "rectangle",
          x = 0,
          y = 420,
          width = 70,
          height = 350,
          rotation = 0,
          visible = true,
          properties = {
            ["collidable"] = true
          }
        },
        {
          id = 10,
          name = "",
          type = "",
          shape = "rectangle",
          x = 140,
          y = 840,
          width = 350,
          height = 70,
          rotation = 0,
          visible = true,
          properties = {
            ["collidable"] = true
          }
        },
        {
          id = 11,
          name = "",
          type = "",
          shape = "rectangle",
          x = 420,
          y = 910,
          width = 70,
          height = 280,
          rotation = 0,
          visible = true,
          properties = {
            ["collidable"] = true
          }
        },
        {
          id = 12,
          name = "",
          type = "",
          shape = "rectangle",
          x = 490,
          y = 1120,
          width = 420,
          height = 70,
          rotation = 0,
          visible = true,
          properties = {
            ["collidable"] = true
          }
        },
        {
          id = 13,
          name = "",
          type = "",
          shape = "rectangle",
          x = 840,
          y = 1190,
          width = 70,
          height = 210,
          rotation = 0,
          visible = true,
          properties = {
            ["collidable"] = true
          }
        },
        {
          id = 14,
          name = "",
          type = "",
          shape = "rectangle",
          x = 910,
          y = 1330,
          width = 840,
          height = 70,
          rotation = 0,
          visible = true,
          properties = {
            ["collidable"] = true
          }
        },
        {
          id = 16,
          name = "",
          type = "",
          shape = "rectangle",
          x = 1680,
          y = 1120,
          width = 70,
          height = 280,
          rotation = 0,
          visible = true,
          properties = {
            ["collidable"] = true
          }
        },
        {
          id = 17,
          name = "",
          type = "",
          shape = "rectangle",
          x = 1680,
          y = 1120,
          width = 490,
          height = 70,
          rotation = 0,
          visible = true,
          properties = {
            ["collidable"] = true
          }
        },
        {
          id = 18,
          name = "",
          type = "",
          shape = "rectangle",
          x = 2100,
          y = 840,
          width = 70,
          height = 350,
          rotation = 0,
          visible = true,
          properties = {
            ["collidable"] = true
          }
        },
        {
          id = 19,
          name = "",
          type = "",
          shape = "rectangle",
          x = 2170,
          y = 840,
          width = 770,
          height = 70,
          rotation = 0,
          visible = true,
          properties = {
            ["collidable"] = true
          }
        },
        {
          id = 20,
          name = "",
          type = "",
          shape = "rectangle",
          x = 2940,
          y = 490,
          width = 70,
          height = 420,
          rotation = 0,
          visible = true,
          properties = {
            ["collidable"] = true
          }
        },
        {
          id = 21,
          name = "",
          type = "",
          shape = "rectangle",
          x = 2380,
          y = 140,
          width = 70,
          height = 350,
          rotation = 0,
          visible = true,
          properties = {
            ["collidable"] = true
          }
        },
        {
          id = 22,
          name = "",
          type = "",
          shape = "rectangle",
          x = 1610,
          y = 140,
          width = 770,
          height = 70,
          rotation = 0,
          visible = true,
          properties = {
            ["collidable"] = true
          }
        },
        {
          id = 23,
          name = "",
          type = "",
          shape = "rectangle",
          x = 1050,
          y = 0,
          width = 490,
          height = 70,
          rotation = 0,
          visible = true,
          properties = {
            ["collidable"] = true
          }
        },
        {
          id = 24,
          name = "",
          type = "",
          shape = "rectangle",
          x = 1610,
          y = 210,
          width = 70,
          height = 350,
          rotation = 0,
          visible = true,
          properties = {
            ["collidable"] = true
          }
        },
        {
          id = 25,
          name = "",
          type = "",
          shape = "rectangle",
          x = 2100,
          y = 560,
          width = 70,
          height = 140,
          rotation = 0,
          visible = true,
          properties = {
            ["collidable"] = true
          }
        },
        {
          id = 26,
          name = "a",
          type = "",
          shape = "polygon",
          x = 0,
          y = 560,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          polygon = {
            { x = 0, y = 0 },
            { x = 280, y = -280 },
            { x = 0, y = -280 }
          },
          properties = {
            ["collidable"] = true
          }
        },
        {
          id = 28,
          name = "d",
          type = "",
          shape = "polygon",
          x = 1400,
          y = 0,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          polygon = {
            { x = 0, y = 0 },
            { x = 280, y = 280 },
            { x = 280, y = 0 }
          },
          properties = {
            ["collidable"] = true
          }
        },
        {
          id = 29,
          name = "e",
          type = "",
          shape = "polygon",
          x = 2240,
          y = 140,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          polygon = {
            { x = 0, y = 0 },
            { x = 210, y = 210 },
            { x = 210, y = 0 }
          },
          properties = {
            ["collidable"] = true
          }
        },
        {
          id = 30,
          name = "f",
          type = "",
          shape = "polygon",
          x = 2800,
          y = 490,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          polygon = {
            { x = 0, y = 0 },
            { x = 210, y = 210 },
            { x = 210, y = 0 }
          },
          properties = {
            ["collidable"] = true
          }
        },
        {
          id = 31,
          name = "",
          type = "",
          shape = "polygon",
          x = 3010,
          y = 700,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          polygon = {
            { x = 0, y = 0 },
            { x = -210, y = 210 },
            { x = 0, y = 210 }
          },
          properties = {
            ["collidable"] = true
          }
        },
        {
          id = 32,
          name = "b",
          type = "",
          shape = "polygon",
          x = -2,
          y = 632,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          polygon = {
            { x = 0, y = 0 },
            { x = 280, y = 280 },
            { x = 70, y = 280 },
            { x = 0, y = 280 }
          },
          properties = {
            ["collidable"] = true
          }
        },
        {
          id = 33,
          name = "",
          type = "",
          shape = "polygon",
          x = 980,
          y = 210,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          polygon = {
            { x = 0, y = 0 },
            { x = 210, y = -210 },
            { x = 0, y = -210 }
          },
          properties = {
            ["collidable"] = true
          }
        }
      }
    },
    {
      type = "objectgroup",
      id = 3,
      name = "Ladders",
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      draworder = "topdown",
      properties = {},
      objects = {
        {
          id = 34,
          name = "",
          type = "",
          shape = "rectangle",
          x = 1680,
          y = 490,
          width = 70,
          height = 350,
          rotation = 0,
          visible = true,
          properties = {
            ["collidable"] = true,
            ["sensor"] = true
          }
        },
        {
          id = 35,
          name = "",
          type = "",
          shape = "rectangle",
          x = 2030,
          y = 840,
          width = 70,
          height = 280,
          rotation = 0,
          visible = true,
          properties = {
            ["collidable"] = true,
            ["sensor"] = true
          }
        },
        {
          id = 36,
          name = "",
          type = "",
          shape = "rectangle",
          x = 840,
          y = 490,
          width = 70,
          height = 350,
          rotation = 0,
          visible = true,
          properties = {
            ["collidable"] = true,
            ["sensor"] = true
          }
        },
        {
          id = 37,
          name = "",
          type = "",
          shape = "rectangle",
          x = 490,
          y = 840,
          width = 70,
          height = 280,
          rotation = 0,
          visible = true,
          properties = {
            ["collidable"] = true,
            ["sensor"] = true
          }
        }
      }
    }
  }
}
