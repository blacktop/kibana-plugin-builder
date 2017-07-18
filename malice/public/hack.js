import $ from 'jquery';
import uiModules from 'ui/modules';
import './less/hack.less';

import uiChrome from 'ui/chrome';
import logoUrl from 'plugins/malice/logo.png';

uiChrome
.setBrand({
  logo: `url(${logoUrl}) left no-repeat`,
  smalllogo: `url(${logoUrl}) left no-repeat`
});

$(document.body).on('keypress', function (event) {
  if (event.which === 58) {
    alert('boo!');
  }
});
