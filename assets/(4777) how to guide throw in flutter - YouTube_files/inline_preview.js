(function(g){var window=this;'use strict';var fpb=function(a){g.U.call(this,{I:"div",S:"ytp-inline-preview-ui"});this.pg=!1;this.player=a;this.T(a,"onStateChange",this.HR);this.T(a,"videodatachange",this.lx);this.T(a,"onInlinePreviewModeChange",this.H6);this.Af=new g.wu(this.uw,null,this);g.L(this,this.Af)},F6=function(a){g.yV.call(this,a);
this.j=new fpb(this.player);g.L(this,this.j);this.j.hide();g.pU(this.player,this.j.element,4);a.isInline()&&(this.load(),a=a.getRootNode(),g.Hu(a,["ytp-inline-preview-mode","ytp-no-contextmenu"]))};
g.w(fpb,g.U);g.k=fpb.prototype;
g.k.rO=function(){this.tooltip=new g.TX(this.player,this);g.L(this,this.tooltip);g.pU(this.player,this.tooltip.element,4);this.tooltip.scale=.6;this.Xc=new g.eW(this.player);g.L(this,this.Xc);this.vk=new g.U({I:"div",Ma:["ytp-inline-preview-scrim"]});g.L(this,this.vk);this.vk.Ea(this.element);this.T(this.vk.element,"click",this.oJ);this.Gj=new g.MX(this.player,this,300);g.L(this,this.Gj);this.Gj.Ea(this.vk.element);this.controls=new g.U({I:"div",S:"ytp-inline-preview-controls"});g.L(this,this.controls);
this.controls.Ea(this.element);var a=new g.dX(this.player,this,!1);g.L(this,a);a.Ea(this.controls.element);a=new g.KX(this.player,this);g.L(this,a);a.Ea(this.controls.element);this.Tc=new g.kX(this.player,this);g.L(this,this.Tc);g.pU(this.player,this.Tc.element,4);this.T(this.player,"appresize",this.Kb);this.T(this.player,"fullscreentoggled",this.Kb);this.Kb()};
g.k.show=function(){g.xu(this.Af);this.pg||(this.rO(),this.pg=!0);0!==this.player.getPlayerState()&&g.U.prototype.show.call(this);this.Tc.show();this.player.Qa("onInlinePreviewUiReady")};
g.k.hide=function(){this.Af.stop();g.U.prototype.hide.call(this);this.player.isInline()||this.pg&&this.Tc.hide()};
g.k.ya=function(){g.U.prototype.ya.call(this)};
g.k.oJ=function(a){a.target===this.vk.element&&this.player.Qa("onExpandInlinePreview",a)};
g.k.H6=function(){g.Ku(this.player.getRootNode(),"ytp-inline-preview-mode",this.player.isInline())};
g.k.Ze=function(){this.Tc.Kc();this.Gj.Kc()};
g.k.uw=function(){this.Ze();g.xu(this.Af)};
g.k.Kb=function(){g.wX(this.Tc,0,this.player.ob().getPlayerSize().width,!1);g.lX(this.Tc)};
g.k.HR=function(a){this.player.isInline()&&(0===a?this.hide():this.show())};
g.k.lx=function(a,b){if(this.player.isInline()){g.Ku(this.player.getRootNode(),"ytp-show-inline-preview-audio-controls",b.aC);var c,d,e;a=!(null==(e=null==(c=b.getPlayerResponse())?void 0:null==(d=c.playerConfig)?void 0:d.inlinePlaybackConfig)||!e.showScrubbingControls);g.Ku(this.player.getRootNode(),"ytp-hide-inline-preview-progress-bar",!a)}};
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
g.k.Jw=function(a,b,c,d,e){var f=d=0,h=0,l=g.fs(a);if(b){c=g.Fu(b,"ytp-mute-button");var m=g.Fu(b,"ytp-subtitles-button"),n=g.ds(b,this.element);b=g.fs(b);d=n.y+40;if(m||c)h=n.x-l.width+b.width}else h=c-l.width/2,f=35;b=this.player.ob().getPlayerSize().width;h=g.re(h,0,b-l.width);d?(a.style.top=d+(e||0)+"px",a.style.bottom=""):(a.style.top="",a.style.bottom=f+"px");a.style.left=h+"px"};
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
g.k.DH=function(){return null};g.w(F6,g.yV);F6.prototype.yl=function(){return!1};
F6.prototype.load=function(){this.player.hideControls();this.j.show()};
F6.prototype.unload=function(){this.player.showControls();this.j.hide()};g.xV("inline_preview",F6);})(_yt_player);