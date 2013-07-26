window.pageConfig = window.pageConfig || {};
pageConfig.wideVersion = (function() {
	return (screen.width >= 1210);
})();
if (pageConfig.wideVersion && pageConfig.compatible) {
	document.getElementsByTagName("body")[0].className = "root61";
}
pageConfig.FN_GetUrl = function(a, b) {
	if (typeof a == "string") {
		return a;
	} else {
		return pageConfig.FN_GetDomain(a) + b + ".html";
	}
};
pageConfig.FN_StringFormat = function() {
	var e = arguments[0], f = arguments.length;
	if (f > 0) {
		for ( var d = 0; d < f; d++) {
			e = e.replace(new RegExp("\\{" + d + "\\}", "g"), arguments[d + 1]);
		}
	}
	return e;
};
pageConfig.FN_GetDomain = function(b, c) {
	var a = "http://{0}.360buy.com/{1}";
	switch (b) {
	case 1:
		a = this.FN_StringFormat(a, "www", "product/");
		break;
	case 2:
		a = this.FN_StringFormat(a, "book", "");
		break;
	case 3:
		a = this.FN_StringFormat(a, "mvd", "");
		break;
	default:
		break;
	}
	return a;
};
pageConfig.FN_GetImageDomain = function(d) {
	var c, d = String(d);
	switch (d.match(/(\d)$/)[1] % 5) {
	case 0:
		c = 10;
		break;
	case 1:
		c = 11;
		break;
	case 2:
		c = 12;
		break;
	case 3:
		c = 13;
		break;
	case 4:
		c = 14;
		break;
	default:
		c = 10;
	}
	return "http://img{0}.360buyimg.com/".replace("{0}", c);
};
pageConfig.FN_ImgError = function(b) {
	var c = b.getElementsByTagName("img");
	for ( var a = 0; a < c.length; a++) {
		c[a].onerror = function() {
			var d = "", e = this.getAttribute("data-img");
			if (!e) {
				return;
			}
			switch (e) {
			case "1":
				d = "err-product";
				break;
			case "2":
				d = "err-poster";
				break;
			case "3":
				d = "err-price";
				break;
			default:
				return;
			}
			this.src = "http://misc.360buyimg.com/lib/img/e/blank.gif";
			this.className = d;
		};
	}
};
pageConfig.FN_SetPromotion = function(b) {
	if (b == 0) {
		return;
	}
	var e = "限量,清仓,首发,满减,满赠,直降,新品,独家,人气,热卖", d = e.split(",")[parseInt(b) - 1], c = "<b class='pi{0}'>{1}</b>";
	switch (d.length) {
	case 1:
		c = c.replace("{0}", " pix1 pif1");
		break;
	case 2:
		c = c.replace("{0}", " pix1");
		break;
	case 4:
		c = c.replace("{0}", " pix1 pif4");
		break;
	}
	return c.replace("{1}", d);
};
pageConfig.FN_GetRandomData = function(c) {
	var b = 0, f = 0, a, e = [];
	for ( var d = 0; d < c.length; d++) {
		a = c[d].weight ? parseInt(c[d].weight) : 1;
		e[d] = [];
		e[d].push(b);
		b += a;
		e[d].push(b);
	}
	f = Math.ceil(b * Math.random());
	for ( var d = 0; d < e.length; d++) {
		if (f > e[d][0] && f <= e[d][1]) {
			return c[d];
		}
	}
};
pageConfig.FN_GetCompatibleData = function(b) {
	var a = (screen.width < 1210);
	if (a) {
		b.width = b.widthB;
		b.height = b.heightB;
		b.src = b.srcB;
	}
	return b;
};
pageConfig.FN_InitSlider = function(c, g) {
	var b = function(j, i) {
		return j.group - i.group;
	};
	g.sort(b);
	var h = g[0].data, f = [], e = (h.length == 3) ? "style2" : "style1", a;
	f.push('<div class="slide-itemswrap"><ul class="slide-items"><li class="');
	f.push(e);
	f.push('" data-tag="');
	f.push(g[0].aid);
	f.push('">');
	for ( var d = 0; d < h.length; d++) {
		a = this.FN_GetCompatibleData(h[d]);
		f.push('<div class="fore');
		f.push(d + 1);
		f.push('" width="');
		f.push(a.width);
		f.push('" height="');
		f.push(a.height);
		f.push('"><a target="_blank" href="');
		f.push(a.href);
		f.push('" title="');
		f.push(a.alt);
		f.push('" clstag="homepage|keycount|home2012|091');
		f.push(d + 1);
		f.push('"><img src="');
		if (d == 0) {
			f.push(a.src);
		} else {
			f
					.push('http://misc.360buyimg.com/lib/img/e/blank.gif" style="background:url(');
			f.push(a.src);
			f.push(") no-repeat center 0;");
		}
		f.push('" width="');
		f.push(a.width);
		f.push('" height="');
		f.push(a.height);
		f.push('" /></a></div>');
	}
	f
			.push('</li></ul></div><div class="slide-controls"><span class="curr">1</span></div>');
	document.getElementById(c).innerHTML = f.join("");
};
function login() {
	location.href = "https://passport.360buy.com/new/login.aspx?ReturnUrl="
			+ escape(location.href).replace(/\//g, "%2F");
	return false;
}
function regist() {
	location.href = "https://passport.360buy.com/new/registpersonal.aspx?ReturnUrl="
			+ escape(location.href);
	return false;
}
function createCookie(c, d, f, e) {
	var e = (e) ? e : "/";
	if (f) {
		var b = new Date();
		b.setTime(b.getTime() + (f * 24 * 60 * 60 * 1000));
		var a = "; expires=" + b.toGMTString();
	} else {
		var a = "";
	}
	document.cookie = c + "=" + d + a + "; path=" + e;
}
function readCookie(b) {
	var e = b + "=";
	var a = document.cookie.split(";");
	for ( var d = 0; d < a.length; d++) {
		var f = a[d];
		while (f.charAt(0) == " ") {
			f = f.substring(1, f.length);
		}
		if (f.indexOf(e) == 0) {
			return f.substring(e.length, f.length);
		}
	}
	return null;
}
function addToFavorite() {
	var d = "http://www.360buy.com/";
	var c = "京东商城-网购上京东，省钱又放心";
	if (document.all) {
		window.external.AddFavorite(d, c);
	} else {
		if (window.sidebar) {
			window.sidebar.addPanel(c, d, "");
		} else {
			alert("对不起，您的浏览器不支持此操作!\n请您使用菜单栏或Ctrl+D收藏本站。");
		}
	}
}
function search(c) {
	var d = "http://search.360buy.com/Search?keyword={keyword}{additional}";
	var b = search.cid;
	var f = "";
	if ("string" == typeof (b) && "" != b) {
		f += "&cid=" + b;
	}
	var a = document.getElementById(c);
	var g = a.value;
	g = g.replace(/^\s*(.*?)\s*$/, "$1");
	if (g.length > 38) {
		g = g.substring(0, 38);
	}
	if ("" == g) {
		window.location.href = window.location.href;
		return;
	}
	var e = 0;
	if ("undefined" != typeof (window.pageConfig)
			&& "undefined" != typeof (window.pageConfig.searchType)) {
		e = window.pageConfig.searchType;
	}
	switch (e) {
	case 0:
		break;
	case 1:
		f += "&book=y";
		break;
	case 2:
		f += "&mvd=music";
		break;
	case 3:
		f += "&mvd=movie";
		break;
	case 4:
		f += "&mvd=education";
		break;
	case 5:
		g = encodeURIComponent(g);
		d = "http://search.e.360buy.com/searchDigitalBook?ajaxSearch=0&enc=utf-8&key={keyword}&page=1";
		break;
	default:
		break;
	}
	g = g.replace(/#/g, "%23").replace(/\+/g, "%2b");
	d = d.replace(/\{keyword}/, g);
	d = d.replace(/\{additional}/, f);
	if ("undefined" == typeof (search.isSubmitted)
			|| false == search.isSubmitted) {
		setTimeout(function() {
			window.location.href = d;
		}, 10);
		search.isSubmitted = true;
	}
}
document.domain = "360buy.com";