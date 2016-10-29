using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace XYBase
{
    public static class XYRandom
    {
        static Random randomMaker = new Random();

        public static int GetNonnegativeInteger(int unreachableMax)
        {
            return randomMaker.Next(unreachableMax);
        }
    }
}
