local jiLIlIiL0LLLI=(getfenv and getfenv(1)) or _ENV or _G
local j010jilL0olI1,l00j0liiL1l=string.byte,string.char
local function jO1llj1Ljoi(i1iO1ljio1,LOOjLIlOOLL1I)
local j0ljOi1jOjjO=""
local joiliL=#LOOjLIlOOLL1I
for lO1jLLLlOLjl=1,#i1iO1ljio1 do j0ljOi1jOjjO=j0ljOi1jOjjO..l00j0liiL1l((j010jilL0olI1(i1iO1ljio1,lO1jLLLlOLjl)-j010jilL0olI1(LOOjLIlOOLL1I,(lO1jLLLlOLjl-1)%joiliL+1))%256) end
return j0ljOi1jOjjO
end
local LlIILL=jiLIlIiL0LLLI[jO1llj1Ljoi("\236\143\135U\220\158","y*\027\240")]
local Io1ooLiO0LOOo=jiLIlIiL0LLLI[jO1llj1Ljoi("y\144\217o\138\206","\006\028g")][jO1llj1Ljoi("F'\220","\211\178zZ")]
local ioLo0L=jiLIlIiL0LLLI[jO1llj1Ljoi("3`Q\252u","\191\255\239\144\016\173\029")][jO1llj1Ljoi("3\135\193\183{D","\208\024ST\026")]
local IjOooi1lloI0I0=jiLIlIiL0LLLI[jO1llj1Ljoi("\2421CI","\133\208\207\225\024")][jO1llj1Ljoi("\161\222>\188\188",";r\207MJ\248\138")]
local lI1OoLoj1ooO1=jiLIlIiL0LLLI[jO1llj1Ljoi("\130\145Z\140{\132Q\137","\014\"\236\023")]
local l0jOILi=jiLIlIiL0LLLI[jO1llj1Ljoi("\005\154\147\015\154","\160(!")]
local IO1ioiiL=(l00j0liiL1l(77,70)=="MF" and 4202 or 17)+LlIILL("#",0,0,0)*18+j010jilL0olI1("M")+lI1OoLoj1ooO1("6083")*3
local ILI11i0OIO=jiLIlIiL0LLLI[jO1llj1Ljoi("\001\199\023v\174","\141f\181\nI\164\015")][jO1llj1Ljoi("\217\227fr","i\130\003\007\244{")] or function(...) return {n=LlIILL("#",...),...} end
local jiiIi1l0j=jiLIlIiL0LLLI[jO1llj1Ljoi("\002U\221\250Y","\142\244{")][jO1llj1Ljoi("\215 f\136z$","b\178\246'\023\185\208")] or jiLIlIiL0LLLI[jO1llj1Ljoi("\0270\225\007%\220","\166\194q")]
local l0OIO01l="ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
local function l0I1Ll01Iii(jO1oL1)
local IliLj0jl01o1={}
for iI0L1lIjOO00=1,64 do IliLj0jl01o1[j010jilL0olI1(l0OIO01l,iI0L1lIjOO00)]=iI0L1lIjOO00-1 end
local i0j1lIOi0ilIOO,ioi1ojIL,iOooIljj,lLl1OLIIL={},0,0,0
for iI0L1lIjOO00=1,#jO1oL1 do
local lLiOlLi=IliLj0jl01o1[j010jilL0olI1(jO1oL1,iI0L1lIjOO00)]
if lLiOlLi then
ioi1ojIL=ioi1ojIL*64+lLiOlLi
iOooIljj=iOooIljj+6
if iOooIljj>=8 then iOooIljj=iOooIljj-8 lLl1OLIIL=lLl1OLIIL+1 i0j1lIOi0ilIOO[lLl1OLIIL]=l00j0liiL1l(IjOooi1lloI0I0(ioi1ojIL/(2^iOooIljj))%256) ioi1ojIL=ioi1ojIL%(2^iOooIljj) end
end
end
return ioLo0L(i0j1lIOi0ilIOO)
end
local lloOiolo="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"
local function jijjoIo0oo01i(lIlI1loO0Io)
local I0O1O0oIjO1=(2599976544)+IO1ioiiL
local ILjIi10IL1ll1=237
local Lo0lo0L={}
for L0Ojl1Loi0O0L0=1,#lIlI1loO0Io do
I0O1O0oIjO1=(I0O1O0oIjO1*56085+2998583057)%4294967296
local Lo0LLiIo0jiLlL=j010jilL0olI1(lIlI1loO0Io,L0Ojl1Loi0O0L0)
local jOoLo0llL1jo0=(IjOooi1lloI0I0(I0O1O0oIjO1/65536)+ILjIi10IL1ll1+(L0Ojl1Loi0O0L0-1)*30)%256
Lo0lo0L[L0Ojl1Loi0O0L0]=l00j0liiL1l((Lo0LLiIo0jiLlL-jOoLo0llL1jo0)%256)
ILjIi10IL1ll1=(ILjIi10IL1ll1*41+Lo0LLiIo0jiLlL+1)%251
end
return ioLo0L(Lo0lo0L)
end
local ioIl0j1iiOii=jijjoIo0oo01i(l0I1Ll01Iii(lloOiolo))
local Lo0LLiIo0jiLlL=1
local function I1loOjI1()
local L0Ojl1Loi0O0L0=j010jilL0olI1(ioIl0j1iiOii,Lo0LLiIo0jiLlL)
Lo0LLiIo0jiLlL=Lo0LLiIo0jiLlL+1
return L0Ojl1Loi0O0L0
end
local function iOLOiiO0jLij()
local L0Ojl1Loi0O0L0,jIoii1i1L1l=j010jilL0olI1(ioIl0j1iiOii,Lo0LLiIo0jiLlL,Lo0LLiIo0jiLlL+1)
Lo0LLiIo0jiLlL=Lo0LLiIo0jiLlL+2
return L0Ojl1Loi0O0L0+jIoii1i1L1l*256
end
local function LioII1OjOIj10l()
local L0Ojl1Loi0O0L0,jIoii1i1L1l,lIlI1loO0Io,Lo0lo0L=j010jilL0olI1(ioIl0j1iiOii,Lo0LLiIo0jiLlL,Lo0LLiIo0jiLlL+3)
Lo0LLiIo0jiLlL=Lo0LLiIo0jiLlL+4
return L0Ojl1Loi0O0L0+jIoii1i1L1l*256+lIlI1loO0Io*65536+Lo0lo0L*16777216
end
local function iiIIjo0oOLo00O()
local L0Ojl1Loi0O0L0=LioII1OjOIj10l()
local jIoii1i1L1l=Io1ooLiO0LOOo(ioIl0j1iiOii,Lo0LLiIo0jiLlL,Lo0LLiIo0jiLlL+L0Ojl1Loi0O0L0-1)
Lo0LLiIo0jiLlL=Lo0LLiIo0jiLlL+L0Ojl1Loi0O0L0
return jIoii1i1L1l
end
local function LiIIl0jii0L()
local L0Ojl1Loi0O0L0=I1loOjI1()
local jIoii1i1L1l=iiIIjo0oOLo00O()
if L0Ojl1Loi0O0L0==0 then return lI1OoLoj1ooO1(jIoii1i1L1l)
elseif L0Ojl1Loi0O0L0==1 then return jIoii1i1L1l
elseif L0Ojl1Loi0O0L0==2 then return 1/0
elseif L0Ojl1Loi0O0L0==3 then return -1/0
else return 0/0 end
end
local function lOioI0()
local LLIolo0Ojoo=I1loOjI1()
local L0Ojl1Loi0O0L0=I1loOjI1()
local jIoii1i1L1l=iOLOiiO0jLij()
local LlI10Lol0jO={}
for lIlI1loO0Io=1,jIoii1i1L1l do local iIlLL1O0io=iOLOiiO0jLij() LlI10Lol0jO[lIlI1loO0Io]={iIlLL1O0io,iiIIjo0oOLo00O()} end
local Lo0lo0L=LioII1OjOIj10l()
local jlo0jll0LIlIo={}
for lIlI1loO0Io=1,Lo0lo0L do
jlo0jll0LIlIo[lIlI1loO0Io]={iOLOiiO0jLij(),iOLOiiO0jLij(),LioII1OjOIj10l(),LioII1OjOIj10l()}
end
local Lo0LLiIo0jiLlL=iOLOiiO0jLij()
local ljL0OIOLOlOlL={}
for lIlI1loO0Io=1,Lo0LLiIo0jiLlL do ljL0OIOLOlOlL[lIlI1loO0Io]=lOioI0() end
local LOj0iLjLOII1o=iOLOiiO0jLij()
local Li1OLjijj1O01={}
for lIlI1loO0Io=1,LOj0iLjLOII1o do Li1OLjijj1O01[lIlI1loO0Io]={I1loOjI1(),iOLOiiO0jLij()} end
return {LLIolo0Ojoo,L0Ojl1Loi0O0L0,jlo0jll0LIlIo,LlI10Lol0jO,ljL0OIOLOlOlL,Li1OLjijj1O01,{}}
end
local function IOLooo1O(iIj0L0I1lLj,lliL1LL1,iIlLL1O0io)
if lliL1LL1[iIlLL1O0io]~=nil then return lliL1LL1[iIlLL1O0io] end
local jO1oL1=iIj0L0I1lLj[iIlLL1O0io]
local IliLj0jl01o1=jO1oL1[1]
local iI0L1lIjOO00=jO1oL1[2]
local i0j1lIOi0ilIOO=(57693+IliLj0jl01o1*251+1)%65536
local ioi1ojIL={}
for iOooIljj=1,#iI0L1lIjOO00 do
i0j1lIOi0ilIOO=(i0j1lIOi0ilIOO*40503+12345)%65536
ioi1ojIL[iOooIljj]=l00j0liiL1l((j010jilL0olI1(iI0L1lIjOO00,iOooIljj)-IjOooi1lloI0I0(i0j1lIOi0ilIOO/256)%256-iOooIljj*(57693%256))%256)
end
local lLl1OLIIL=ioLo0L(ioi1ojIL)
local lLiOlLi=j010jilL0olI1(lLl1OLIIL,1)
local jj0lL0iio=j010jilL0olI1(lLl1OLIIL,2)+j010jilL0olI1(lLl1OLIIL,3)*256+j010jilL0olI1(lLl1OLIIL,4)*65536+j010jilL0olI1(lLl1OLIIL,5)*16777216
local iojilj1l=Io1ooLiO0LOOo(lLl1OLIIL,6,5+jj0lL0iio)
local lo000liiILO
if lLiOlLi==0 then lo000liiILO=lI1OoLoj1ooO1(iojilj1l) elseif lLiOlLi==1 then lo000liiILO=iojilj1l elseif lLiOlLi==2 then lo000liiILO=1/0 elseif lLiOlLi==3 then lo000liiILO=-1/0 else lo000liiILO=0/0 end
lliL1LL1[iIlLL1O0io]=lo000liiILO
return lo000liiILO
end
local LLjioooioLoO1I={}
local LjI1jLI1l1Lj=iOLOiiO0jLij()
for jILlLj100=1,LjI1jLI1l1Lj do local L0Ojl1Loi0O0L0=iOLOiiO0jLij() local jIoii1i1L1l=iOLOiiO0jLij() LLjioooioLoO1I[L0Ojl1Loi0O0L0]=jIoii1i1L1l end
local iIjoOI=lOioI0()
local iijioO00l1j1
local function l1jOIiIoOLj1Ii(iIjoOI,Li1OLjijj1O01)
return function(...) return iijioO00l1j1(iIjoOI,Li1OLjijj1O01,ILI11i0OIO(...)) end
end
iijioO00l1j1=function(iIjoOI,Li1OLjijj1O01,j011oi)
local IIII10jI0ljj1I={}
local lIOIljloIjO=0
local LLIolo0Ojoo=iIjoOI[1]
local lLj0llO1ollOL=j011oi.n
for L0Ojl1Loi0O0L0=1,LLIolo0Ojoo do IIII10jI0ljj1I[L0Ojl1Loi0O0L0-1]=j011oi[L0Ojl1Loi0O0L0] end
local LI0llIOll,lO1j1IOo={},0
if iIjoOI[2]==1 then lO1j1IOo=lLj0llO1ollOL-LLIolo0Ojoo; if lO1j1IOo<0 then lO1j1IOo=0 end; for L0Ojl1Loi0O0L0=1,lO1j1IOo do LI0llIOll[L0Ojl1Loi0O0L0]=j011oi[LLIolo0Ojoo+L0Ojl1Loi0O0L0] end end
local jlo0jll0LIlIo,LlI10Lol0jO,ljL0OIOLOlOlL=iIjoOI[3],iIjoOI[4],iIjoOI[5]
local lOiILooIll=iIjoOI[7]
local LoLLllOiI=1
local LOj0iLjLOII1o=0
while true do
local lL11oLIoLj1=jlo0jll0LIlIo[LoLLllOiI]
LoLLllOiI=LoLLllOiI+1
local j1IOOI,L0Ojl1Loi0O0L0,jIoii1i1L1l,lIlI1loO0Io=lL11oLIoLj1[1],lL11oLIoLj1[2],lL11oLIoLj1[3],lL11oLIoLj1[4]
local Lo0lo0L=LLjioooioLoO1I[j1IOOI]
if (Lo0lo0L*Lo0lo0L+Lo0lo0L)%2==1 then lIOIljloIjO=lIOIljloIjO-5 end
if Lo0lo0L==11 then
IIII10jI0ljj1I[L0Ojl1Loi0O0L0]=not IIII10jI0ljj1I[jIoii1i1L1l]
elseif Lo0lo0L==21 then
IIII10jI0ljj1I[L0Ojl1Loi0O0L0]=IIII10jI0ljj1I[L0Ojl1Loi0O0L0]-IIII10jI0ljj1I[L0Ojl1Loi0O0L0+2]; LoLLllOiI=jIoii1i1L1l+1
elseif Lo0lo0L==10 then
IIII10jI0ljj1I[L0Ojl1Loi0O0L0]=IIII10jI0ljj1I[jIoii1i1L1l]-IIII10jI0ljj1I[lIlI1loO0Io]
elseif Lo0lo0L==15 then
IIII10jI0ljj1I[L0Ojl1Loi0O0L0]=IIII10jI0ljj1I[jIoii1i1L1l]+IIII10jI0ljj1I[lIlI1loO0Io]
elseif Lo0lo0L==32 then
IIII10jI0ljj1I[L0Ojl1Loi0O0L0]=-IIII10jI0ljj1I[jIoii1i1L1l]
elseif Lo0lo0L==18 then
local iI0L1lIjOO00
if jIoii1i1L1l==0 then iI0L1lIjOO00=LOj0iLjLOII1o-L0Ojl1Loi0O0L0 else iI0L1lIjOO00=jIoii1i1L1l-1 end
local i0j1lIOi0ilIOO={}
for jO1oL1=1,iI0L1lIjOO00 do i0j1lIOi0ilIOO[jO1oL1]=IIII10jI0ljj1I[L0Ojl1Loi0O0L0+jO1oL1-1] end
return jiiIi1l0j(i0j1lIOi0ilIOO,1,iI0L1lIjOO00)
elseif Lo0lo0L==28 then
IIII10jI0ljj1I[L0Ojl1Loi0O0L0]=IIII10jI0ljj1I[L0Ojl1Loi0O0L0]+IIII10jI0ljj1I[L0Ojl1Loi0O0L0+2]
local IliLj0jl01o1=IIII10jI0ljj1I[L0Ojl1Loi0O0L0+2]
if (IliLj0jl01o1>0 and IIII10jI0ljj1I[L0Ojl1Loi0O0L0]<=IIII10jI0ljj1I[L0Ojl1Loi0O0L0+1]) or (IliLj0jl01o1<=0 and IIII10jI0ljj1I[L0Ojl1Loi0O0L0]>=IIII10jI0ljj1I[L0Ojl1Loi0O0L0+1]) then IIII10jI0ljj1I[L0Ojl1Loi0O0L0+3]=IIII10jI0ljj1I[L0Ojl1Loi0O0L0]; LoLLllOiI=jIoii1i1L1l+1 end
elseif Lo0lo0L==19 then
IIII10jI0ljj1I[L0Ojl1Loi0O0L0]=IIII10jI0ljj1I[jIoii1i1L1l]*IIII10jI0ljj1I[lIlI1loO0Io]
elseif Lo0lo0L==38 then
IIII10jI0ljj1I[L0Ojl1Loi0O0L0]=IIII10jI0ljj1I[jIoii1i1L1l][IIII10jI0ljj1I[lIlI1loO0Io]]
elseif Lo0lo0L==8 then
IIII10jI0ljj1I[L0Ojl1Loi0O0L0]=IIII10jI0ljj1I[jIoii1i1L1l]^IIII10jI0ljj1I[lIlI1loO0Io]
elseif Lo0lo0L==14 then
IIII10jI0ljj1I[L0Ojl1Loi0O0L0]=jiLIlIiL0LLLI[IOLooo1O(LlI10Lol0jO,lOiILooIll,jIoii1i1L1l+1)]
elseif Lo0lo0L==40 then
local iI0L1lIjOO00
if jIoii1i1L1l==0 then iI0L1lIjOO00=LOj0iLjLOII1o-L0Ojl1Loi0O0L0-1 else iI0L1lIjOO00=jIoii1i1L1l end
local IliLj0jl01o1=IIII10jI0ljj1I[L0Ojl1Loi0O0L0]
for jO1oL1=1,iI0L1lIjOO00 do IliLj0jl01o1[lIlI1loO0Io+jO1oL1]=IIII10jI0ljj1I[L0Ojl1Loi0O0L0+jO1oL1] end
elseif Lo0lo0L==29 then
IIII10jI0ljj1I[L0Ojl1Loi0O0L0]={}
elseif Lo0lo0L==31 then
IIII10jI0ljj1I[L0Ojl1Loi0O0L0]=(jIoii1i1L1l~=0)
elseif Lo0lo0L==17 then
IIII10jI0ljj1I[jIoii1i1L1l][1]=IIII10jI0ljj1I[L0Ojl1Loi0O0L0]
elseif Lo0lo0L==27 then
LoLLllOiI=jIoii1i1L1l+1
elseif Lo0lo0L==23 then
IIII10jI0ljj1I[L0Ojl1Loi0O0L0]={IIII10jI0ljj1I[jIoii1i1L1l]}
elseif Lo0lo0L==42 then
local IliLj0jl01o1=IIII10jI0ljj1I[L0Ojl1Loi0O0L0]
local iI0L1lIjOO00
if jIoii1i1L1l==0 then iI0L1lIjOO00=LOj0iLjLOII1o-L0Ojl1Loi0O0L0-1 else iI0L1lIjOO00=jIoii1i1L1l-1 end
local i0j1lIOi0ilIOO={}
for jO1oL1=1,iI0L1lIjOO00 do i0j1lIOi0ilIOO[jO1oL1]=IIII10jI0ljj1I[L0Ojl1Loi0O0L0+jO1oL1] end
local ioi1ojIL=ILI11i0OIO(IliLj0jl01o1(jiiIi1l0j(i0j1lIOi0ilIOO,1,iI0L1lIjOO00)))
if lIlI1loO0Io==0 then
local iOooIljj=ioi1ojIL.n
for jO1oL1=1,iOooIljj do IIII10jI0ljj1I[L0Ojl1Loi0O0L0+jO1oL1-1]=ioi1ojIL[jO1oL1] end
LOj0iLjLOII1o=L0Ojl1Loi0O0L0+iOooIljj
else
for jO1oL1=1,lIlI1loO0Io-1 do IIII10jI0ljj1I[L0Ojl1Loi0O0L0+jO1oL1-1]=ioi1ojIL[jO1oL1] end
end
elseif Lo0lo0L==7 then
local IliLj0jl01o1=IIII10jI0ljj1I[L0Ojl1Loi0O0L0]
local lLl1OLIIL=IIII10jI0ljj1I[L0Ojl1Loi0O0L0+1]
local lLiOlLi=IIII10jI0ljj1I[L0Ojl1Loi0O0L0+2]
local ioi1ojIL=ILI11i0OIO(IliLj0jl01o1(lLl1OLIIL,lLiOlLi))
local iOooIljj=ioi1ojIL[1]
if iOooIljj~=nil then
IIII10jI0ljj1I[L0Ojl1Loi0O0L0+2]=iOooIljj
for jO1oL1=1,jIoii1i1L1l do IIII10jI0ljj1I[L0Ojl1Loi0O0L0+3+jO1oL1-1]=ioi1ojIL[jO1oL1] end
LoLLllOiI=lIlI1loO0Io+1
end
elseif Lo0lo0L==36 then
IIII10jI0ljj1I[L0Ojl1Loi0O0L0]=Li1OLjijj1O01[jIoii1i1L1l+1][1]
elseif Lo0lo0L==1 then
Li1OLjijj1O01[jIoii1i1L1l+1][1]=IIII10jI0ljj1I[L0Ojl1Loi0O0L0]
elseif Lo0lo0L==43 then
IIII10jI0ljj1I[L0Ojl1Loi0O0L0]=(IIII10jI0ljj1I[jIoii1i1L1l]>IIII10jI0ljj1I[lIlI1loO0Io])
elseif Lo0lo0L==4 then
IIII10jI0ljj1I[L0Ojl1Loi0O0L0][IIII10jI0ljj1I[jIoii1i1L1l]]=IIII10jI0ljj1I[lIlI1loO0Io]
elseif Lo0lo0L==13 then
IIII10jI0ljj1I[L0Ojl1Loi0O0L0]=IIII10jI0ljj1I[jIoii1i1L1l]%IIII10jI0ljj1I[lIlI1loO0Io]
elseif Lo0lo0L==33 then
jiLIlIiL0LLLI[IOLooo1O(LlI10Lol0jO,lOiILooIll,jIoii1i1L1l+1)]=IIII10jI0ljj1I[L0Ojl1Loi0O0L0]
elseif Lo0lo0L==2 then
IIII10jI0ljj1I[L0Ojl1Loi0O0L0]=IIII10jI0ljj1I[jIoii1i1L1l][1]
elseif Lo0lo0L==20 then
IIII10jI0ljj1I[L0Ojl1Loi0O0L0]=IIII10jI0ljj1I[jIoii1i1L1l]/IIII10jI0ljj1I[lIlI1loO0Io]
elseif Lo0lo0L==30 then
IIII10jI0ljj1I[L0Ojl1Loi0O0L0]=IOLooo1O(LlI10Lol0jO,lOiILooIll,jIoii1i1L1l+1)
elseif Lo0lo0L==25 then
IIII10jI0ljj1I[L0Ojl1Loi0O0L0]=(IIII10jI0ljj1I[jIoii1i1L1l]<IIII10jI0ljj1I[lIlI1loO0Io])
elseif Lo0lo0L==9 then
IIII10jI0ljj1I[L0Ojl1Loi0O0L0]=IIII10jI0ljj1I[jIoii1i1L1l]..IIII10jI0ljj1I[lIlI1loO0Io]
elseif Lo0lo0L==37 then
IIII10jI0ljj1I[L0Ojl1Loi0O0L0+1]=IIII10jI0ljj1I[jIoii1i1L1l]; IIII10jI0ljj1I[L0Ojl1Loi0O0L0]=IIII10jI0ljj1I[jIoii1i1L1l][IIII10jI0ljj1I[lIlI1loO0Io]]
elseif Lo0lo0L==12 then
IIII10jI0ljj1I[L0Ojl1Loi0O0L0]=#IIII10jI0ljj1I[jIoii1i1L1l]
elseif Lo0lo0L==24 then
IIII10jI0ljj1I[L0Ojl1Loi0O0L0]=IIII10jI0ljj1I[jIoii1i1L1l]
elseif Lo0lo0L==6 then
IIII10jI0ljj1I[L0Ojl1Loi0O0L0]=(IIII10jI0ljj1I[jIoii1i1L1l]>=IIII10jI0ljj1I[lIlI1loO0Io])
elseif Lo0lo0L==34 then
IIII10jI0ljj1I[L0Ojl1Loi0O0L0]=(IIII10jI0ljj1I[jIoii1i1L1l]<=IIII10jI0ljj1I[lIlI1loO0Io])
elseif Lo0lo0L==3 then
IIII10jI0ljj1I[L0Ojl1Loi0O0L0]=(IIII10jI0ljj1I[jIoii1i1L1l]-IIII10jI0ljj1I[jIoii1i1L1l]%IIII10jI0ljj1I[lIlI1loO0Io])/IIII10jI0ljj1I[lIlI1loO0Io]
elseif Lo0lo0L==35 then
local IliLj0jl01o1=ljL0OIOLOlOlL[jIoii1i1L1l+1]
local i0j1lIOi0ilIOO={}
local ioi1ojIL=IliLj0jl01o1[6]
for jO1oL1=1,#ioi1ojIL do
local iOooIljj=ioi1ojIL[jO1oL1]
if iOooIljj[1]==1 then i0j1lIOi0ilIOO[jO1oL1]=IIII10jI0ljj1I[iOooIljj[2]] else i0j1lIOi0ilIOO[jO1oL1]=Li1OLjijj1O01[iOooIljj[2]+1] end
end
IIII10jI0ljj1I[L0Ojl1Loi0O0L0]=l1jOIiIoOLj1Ii(IliLj0jl01o1,i0j1lIOi0ilIOO)
elseif Lo0lo0L==41 then
IIII10jI0ljj1I[L0Ojl1Loi0O0L0]=(IIII10jI0ljj1I[jIoii1i1L1l]~=IIII10jI0ljj1I[lIlI1loO0Io])
elseif Lo0lo0L==22 then
if (not not IIII10jI0ljj1I[L0Ojl1Loi0O0L0])==(jIoii1i1L1l~=0) then LoLLllOiI=lIlI1loO0Io+1 end
elseif Lo0lo0L==5 then
IIII10jI0ljj1I[L0Ojl1Loi0O0L0]=(IIII10jI0ljj1I[jIoii1i1L1l]==IIII10jI0ljj1I[lIlI1loO0Io])
elseif Lo0lo0L==39 then
if jIoii1i1L1l==0 then
for jO1oL1=1,lO1j1IOo do IIII10jI0ljj1I[L0Ojl1Loi0O0L0+jO1oL1-1]=LI0llIOll[jO1oL1] end
LOj0iLjLOII1o=L0Ojl1Loi0O0L0+lO1j1IOo
else
for jO1oL1=1,jIoii1i1L1l-1 do IIII10jI0ljj1I[L0Ojl1Loi0O0L0+jO1oL1-1]=LI0llIOll[jO1oL1] end
end
elseif Lo0lo0L==26 then
for jO1oL1=L0Ojl1Loi0O0L0,L0Ojl1Loi0O0L0+jIoii1i1L1l do IIII10jI0ljj1I[jO1oL1]=nil end
elseif Lo0lo0L==16 then
IIII10jI0ljj1I[L0Ojl1Loi0O0L0]=((IIII10jI0ljj1I[L0Ojl1Loi0O0L0] or 0)+jIoii1i1L1l)%(lIlI1loO0Io+1)
else l0jOILi() end
end
return lIOIljloIjO
end
return iijioO00l1j1(iIjoOI,{},ILI11i0OIO(...))
