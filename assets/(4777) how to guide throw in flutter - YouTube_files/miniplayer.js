(function(g){var window=this;'use strict';var opb=function(a,b){g.U.call(this,{I:"button",Ma:["ytp-miniplayer-expand-watch-page-button","ytp-button","ytp-miniplayer-button-top-left"],W:{title:"{{title}}","data-tooltip-target-id":"ytp-miniplayer-expand-watch-page-button","aria-keyshortcuts":"i","data-title-no-tooltip":"{{data-title-no-tooltip}}"},V:[{I:"svg",W:{height:"24px",version:"1.1",viewBox:"0 0 24 24",width:"24px"},V:[{I:"g",W:{fill:"none","fill-rule":"evenodd",stroke:"none","stroke-width":"1"},V:[{I:"g",W:{transform:"translate(12.000000, 12.000000) scale(-1, 1) translate(-12.000000, -12.000000) "},
V:[{I:"path",W:{d:"M19,19 L5,19 L5,5 L12,5 L12,3 L5,3 C3.89,3 3,3.9 3,5 L3,19 C3,20.1 3.89,21 5,21 L19,21 C20.1,21 21,20.1 21,19 L21,12 L19,12 L19,19 Z M14,3 L14,5 L17.59,5 L7.76,14.83 L9.17,16.24 L19,6.41 L19,10 L21,10 L21,3 L14,3 Z",fill:"#fff","fill-rule":"nonzero"}}]}]}]}]});this.J=a;this.Sa("click",this.onClick,this);this.updateValue("title",g.JU(a,"Expand","i"));this.update({"data-title-no-tooltip":"Expand"});g.wb(this,g.DU(b.Fc(),this.element))},ppb=function(a){g.U.call(this,{I:"div",
S:"ytp-miniplayer-ui"});this.pg=!1;this.player=a;this.T(a,"minimized",this.Ah);this.T(a,"onStateChange",this.HR)},qpb=function(a){g.yV.call(this,a);
this.B=new g.PK(this);this.j=new ppb(this.player);this.j.hide();g.pU(this.player,this.j.element,4);a.rg()&&(this.load(),g.Ku(a.getRootNode(),"ytp-player-minimized",!0))};
g.w(opb,g.U);opb.prototype.onClick=function(){this.J.Qa("onExpandMiniplayer")};g.w(ppb,g.U);g.k=ppb.prototype;
g.k.rO=function(){this.tooltip=new g.TX(this.player,this);g.L(this,this.tooltip);g.pU(this.player,this.tooltip.element,4);this.tooltip.scale=.6;this.Xc=new g.eW(this.player);g.L(this,this.Xc);this.vk=new g.U({I:"div",S:"ytp-miniplayer-scrim"});g.L(this,this.vk);this.vk.Ea(this.element);this.T(this.vk.element,"click",this.oJ);var a=new g.U({I:"button",Ma:["ytp-miniplayer-close-button","ytp-button"],W:{"aria-label":"Close"},V:[g.rG()]});g.L(this,a);a.Ea(this.vk.element);this.T(a.element,"click",this.Lp);
a=new opb(this.player,this);g.L(this,a);a.Ea(this.vk.element);this.fv=new g.U({I:"div",S:"ytp-miniplayer-controls"});g.L(this,this.fv);this.fv.Ea(this.vk.element);this.T(this.fv.element,"click",this.oJ);var b=new g.U({I:"div",S:"ytp-miniplayer-button-container"});g.L(this,b);b.Ea(this.fv.element);a=new g.U({I:"div",S:"ytp-miniplayer-play-button-container"});g.L(this,a);a.Ea(this.fv.element);var c=new g.U({I:"div",S:"ytp-miniplayer-button-container"});g.L(this,c);c.Ea(this.fv.element);this.lZ=new g.fX(this.player,
this,!1);g.L(this,this.lZ);this.lZ.Ea(b.element);b=new g.eX(this.player,this);g.L(this,b);b.Ea(a.element);this.nextButton=new g.fX(this.player,this,!0);g.L(this,this.nextButton);this.nextButton.Ea(c.element);this.Gj=new g.MX(this.player,this);g.L(this,this.Gj);this.Gj.Ea(this.vk.element);this.Tc=new g.kX(this.player,this);g.L(this,this.Tc);g.pU(this.player,this.Tc.element,4);this.YI=new g.U({I:"div",S:"ytp-miniplayer-buttons"});g.L(this,this.YI);g.pU(this.player,this.YI.element,4);a=new g.U({I:"button",
Ma:["ytp-miniplayer-close-button","ytp-button"],W:{"aria-label":"Close"},V:[g.rG()]});g.L(this,a);a.Ea(this.YI.element);this.T(a.element,"click",this.Lp);a=new g.U({I:"button",Ma:["ytp-miniplayer-replay-button","ytp-button"],W:{"aria-label":"Close"},V:[g.sva()]});g.L(this,a);a.Ea(this.YI.element);this.T(a.element,"click",this.q9);this.T(this.player,"presentingplayerstatechange",this.Wd);this.T(this.player,"appresize",this.Kb);this.T(this.player,"fullscreentoggled",this.Kb);this.Kb()};
g.k.show=function(){this.Af=new g.wu(this.uw,null,this);this.Af.start();this.pg||(this.rO(),this.pg=!0);0!==this.player.getPlayerState()&&g.U.prototype.show.call(this);this.Tc.show();this.player.unloadModule("annotations_module")};
g.k.hide=function(){this.Af&&(this.Af.dispose(),this.Af=void 0);g.U.prototype.hide.call(this);this.player.rg()||(this.pg&&this.Tc.hide(),this.player.loadModule("annotations_module"))};
g.k.ya=function(){this.Af&&(this.Af.dispose(),this.Af=void 0);g.U.prototype.ya.call(this)};
g.k.Lp=function(){this.player.stopVideo();this.player.Qa("onCloseMiniplayer")};
g.k.q9=function(){this.player.playVideo()};
g.k.oJ=function(a){if(a.target===this.vk.element||a.target===this.fv.element)g.ML(this.player.Tb())?this.player.pauseVideo():this.player.playVideo()};
g.k.Ah=function(){g.Ku(this.player.getRootNode(),"ytp-player-minimized",this.player.rg())};
g.k.Ze=function(){this.Tc.Kc();this.Gj.Kc()};
g.k.uw=function(){this.Ze();this.Af&&this.Af.start()};
g.k.Wd=function(a){g.SG(a.state,32)&&this.tooltip.hide()};
g.k.Kb=function(){g.wX(this.Tc,0,this.player.ob().getPlayerSize().width,!1);g.lX(this.Tc)};
g.k.HR=function(a){this.player.rg()&&(0===a?this.hide():this.show())};
g.k.Fc=function(){return this.tooltip};
g.k.Jg=function(){return!1};
g.k.wg=function(){return!1};
g.k.qm=function(){return!1};
g.k.kK=function(){};
g.k.Ks=function(){};
g.k.Yy=function(){};
g.k.qn=function(){return null};
g.k.CH=function(){return null};
g.k.JN=function(){return new g.Ce(0,0)};
g.k.Pk=function(){return new g.Sr(0,0,0,0)};
g.k.handleGlobalKeyDown=function(){return!1};
g.k.handleGlobalKeyUp=function(){return!1};
g.k.Jw=function(a,b,c,d,e){var f=0,h=d=0,l=g.fs(a);if(b){c=g.Fu(b,"ytp-prev-button")||g.Fu(b,"ytp-next-button");var m=g.Fu(b,"ytp-play-button"),n=g.Fu(b,"ytp-miniplayer-expand-watch-page-button");c?f=h=12:m?(b=g.ds(b,this.element),h=b.x,f=b.y-12):n&&(h=g.Fu(b,"ytp-miniplayer-button-top-left"),f=g.ds(b,this.element),b=g.fs(b),h?(h=8,f=f.y+40):(h=f.x-l.width+b.width,f=f.y-20))}else h=c-l.width/2,d=25+(e||0);b=this.player.ob().getPlayerSize().width;e=f+(e||0);l=g.re(h,0,b-l.width);e?(a.style.top=e+"px",
a.style.bottom=""):(a.style.top="",a.style.bottom=d+"px");a.style.left=l+"px"};
g.k.showControls=function(){};
g.k.bq=function(){};
g.k.gm=function(){return!1};
g.k.wF=function(){};
g.k.aB=function(){};
g.k.Gr=function(){};
g.k.Fr=function(){};
g.k.Lu=function(){};
g.k.Ms=function(){};
g.k.cF=function(){};
g.k.DH=function(){return null};g.w(qpb,g.yV);g.k=qpb.prototype;g.k.onVideoDataChange=function(){if(this.player.getVideoData()){var a=this.player.getVideoAspectRatio(),b=16/9;a=a>b+.1||a<b-.1;g.Ku(this.player.getRootNode(),"ytp-rounded-miniplayer-not-regular-wide-video",a)}};
g.k.create=function(){g.yV.prototype.create.call(this);this.B.T(this.player,"videodatachange",this.onVideoDataChange);this.onVideoDataChange()};
g.k.yl=function(){return!1};
g.k.load=function(){this.player.hideControls();this.j.show()};
g.k.unload=function(){this.player.showControls();this.j.hide()};g.xV("miniplayer",qpb);})(_yt_player);
