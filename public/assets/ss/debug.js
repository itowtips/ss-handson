(function(){this.SS_Debug=function(){function c(){}return c.doing=!1,c.run=function(){return $("#log").val(""),$("#err").val(""),$("#queue").val("0"),this.doing=!0,this.connect_url(location.href)},c.stop=function(){return this.doing=!1},c.connect_url=function(e,r){var t,a,n,l;if(null==r&&(r=null),!1!==this.doing&&void 0!==e&&""!==e&&!e.match(/^#/)&&!e.match(/^[^h]\w+:/)&&!(e.match(/\/logout$/)||e.match(/^\/\..*?\/uploader/)||e.match(/^\/\..*?\/db/)||e.match(/^\/\..*?\/history/))){if((e=e.replace(/#.*/,"")).match(/^https?:/)){if(!e.match(new RegExp("^https?://"+location.host)))return;e=e.replace(/^https?:\/\/.*?\//,"/")}else e.match(/^[^\/]/)&&(e=r.replace(/\/[^\/]*$/,"")+"/"+e);return l=$("#log"),a=(t=(t=(t=e).replace(/\d+/g,"123")).replace(/\?s(\[|\%123).*/g,"")).replace(/[\-\[\]\/\{\}\(\)\*\+\?\.\\\^\$\|]/g,"\\$&"),l.val().match(new RegExp("^"+a+"$","m"))?!0:(l.val(l.val()+t+"\n"),l.scrollTop(l[0].scrollHeight-l.height()),(n=$("#queue")).val(parseInt(n.val())+1),$.ajax({type:"GET",url:e,dataType:"html",cache:!1,success:function(t){return n.val(parseInt(n.val())-1),$($.parseHTML(t.replace(/<img[^>]*>/gi,""))).find("a").each(function(){return!$(this).is("[href]")||c.connect_url($(this).attr("href"),e)})},error:function(t){return n.val(parseInt(n.val())-1),(l=$("#err")).val(l.val()+" ["+t.status+"] "+e+" - Referer: "+r+"\n"),l.scrollTop(l[0].scrollHeight-l.height())}}))}},c}()}).call(this);