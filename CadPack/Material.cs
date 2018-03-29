/* Constructor for Material Layers
 * Controls Layer Name & Color in CAD
 */

namespace CadPack
{
    class Material
    {
        public string Name;
        public string Color;

        public Material(string nme, string clr)
        {
            Name = nme;
            Color = clr;
        }

    }
}
