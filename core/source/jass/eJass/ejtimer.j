#ifndef ejtimerIncluded
#define ejtimerIncluded

library_once ejtimer
    // 设计：飝夫斯基、苍老湿 制作：飝夫斯基
    public int array I
    public real array R
    public unit array U
    public timer array T
    public group array G
    public string array S
    public player array P
    public boolean array B
    public effect array E
    private int array index[80955]
    private int array Dindex[80955]
    private int max=-1
    private int Dmax=-1

    func EJNewIndex(timer t)>int
        int i
        if Dmax==-1
            max++
            i=max
        else
            i=Dindex[Dmax]
            Dmax--
        end
        index[GetHandleId(t)-0x100000]=i
        return i
    end

    func EJDestroyIndex(timer t)
        int id=GetHandleId(t)-0x100000
        int i=index[id]
        PauseTimer(t)
        DestroyTimer(t)
        if  i!=-1
            index[id]=-1
            if i==max
                max--
            else
                Dmax++
                Dindex[Dmax]=i
            end
        end
    end
    func EJGetTimerIndex(timer t)>int
        return index[GetHandleId(t)-0x100000]
    end
end

#endif
