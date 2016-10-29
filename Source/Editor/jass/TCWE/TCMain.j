library_once TCMain initializer Init

    globals
        hashtable TCHash
        public string emptyStr
    endglobals
    
    private function Init takes nothing returns nothing
        set TCHash=InitHashtable()
        set emptyStr=""
    endfunction
    
endlibrary
