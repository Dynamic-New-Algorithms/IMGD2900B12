var DNA

DNA = {
    Master_Grid: null,
    Zoom: 1,
    Off_Set:{ x: 1, y: 1 },
    changed: true
}


DNA.Build_blank_master_Grid = function(width,height)
{
    var x;
    var y;
    DNA.Master_Grid = [];
    for(x = 0;x < width;x++)
    {
        var col;
        col = [];
        for(y=0;y < height;y++)
        {
            col.push(
                {
                    Color:
                    {
                        RGB: {r: 0,g: 0,b: 0},
                        alpha: 100,
                        HEX: 0x000000,
                        changed: true
                    },
                    Border:
                    {
                        RGB: {r: 0,g: 0,b: 0},
                        HEX: 0x000000,
                        alpha: 100,
                        Width: 0,
                        changed: true
                    },
                    Glyph:
                    {
                        RGB: {r: 0,g: 0,b: 0},
                        HEX: 0x000000,
                        Value: 0,
                        changed: true
                    }
                }
            );
        }
        DNA.Master_Grid.push(col);
    }
};

DNA.Draw = function()
{
    if(DNA.changed)
    {
        var data, x, y,xi,yi;
        data = {width: DNA.Zoom*2+1,height: DNA.Zoom*2+1,pixelSize: 3, data: []}
        yi = 0
        for(y = DNA.Off_Set.y-DNA.Zoom;y <= DNA.Off_Set.y+DNA.Zoom;y++)
        {
            xi = 0
            for(x = DNA.Off_Set.x-DNA.Zoom;y <= DNA.Off_Set.x+DNA.Zoom;x++)
            {
                data.data.push(DNA.Master_Grid[x][y].Color.r);
                data.data.push(DNA.Master_Grid[x][y].Color.g);
                data.data.push(DNA.Master_Grid[x][y].Color.b);
                DNA.Master_Grid[x][y].Color.changed = false
                if(DNA.Master_Grid[x][y].Border.changed)
                {
                    PS.BeadBorderColor(xi,yi,DNA.Master_Grid[x][y].Border.RGB)
                    PS.BeadBorderWidth(xi,yi,Math.floor(DNA.Master_Grid[x][y].Border.Width) );
                }
            }
        }
    }

};
