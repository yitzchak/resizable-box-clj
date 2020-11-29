import {
  LayoutModel,
  LayoutView
} from '@jupyter-widgets/base';

import {
  GridBoxModel,
  GridBoxView
} from '@jupyter-widgets/controls';


// Import the CSS
import '../css/widget.css';


import { MODULE_NAME, MODULE_VERSION } from './version';


export class ResizableLayoutModel extends LayoutModel {

  defaults() {
    return {
      ...super.defaults(),

      resize: null,

      _model_name: 'ResizableLayoutModel',
      _model_module: MODULE_NAME,
      _model_module_version: MODULE_VERSION,
      _view_name: 'ResizableLayoutView',
      _view_module: MODULE_NAME,
      _view_module_version: MODULE_VERSION,
    };
  }

}


export class ResizableLayoutView extends LayoutView {

  initialize(parameters: any): void {
    super.initialize(parameters);
    this.registerTrait('resize');
  }

}


export class ResizableGridBoxModel extends GridBoxModel {

  defaults() {
    return {
      ...super.defaults(),

      enable_full_screen: false,

      _model_name: 'ResizableGridBoxModel',
      _model_module: MODULE_NAME,
      _model_module_version: MODULE_VERSION,
      _view_name: 'ResizableGridBoxView',
      _view_module: MODULE_NAME,
      _view_module_version: MODULE_VERSION,
    };
  }

}


export class ResizableGridBoxView extends GridBoxView {

  resize_observer: any;
  full_screen_button: any;

  initialize(parameters: any): void {
    super.initialize(parameters);

    this.model.on('msg:custom', this.handle_custom_message.bind(this));
    this.model.on('change:enable_full_screen', (event: any) => {
      if (event.changed.enable_full_screen) {
        this.full_screen_button.style.display = null;
      } else {
        this.full_screen_button.style.display = "none";
      }
    });

    document.addEventListener("fullscreenchange", this.on_fullscreenchange.bind(this));

    this.resize_observer = new ResizeObserver(() => {
      if (this.children_views) {
        this.update_children();
      }
    });
  }

  on_fullscreenchange(event: any): void {
    if (event.target === this.el) {
      this.send({ event: "full_screen", state: document.fullscreenElement === this.el });
    }
  }

  handle_custom_message(content: any): void {
    switch (content.do) {
      case 'enter_full_screen':
        this.el.requestFullscreen();
        break;
      case 'exit_full_screen':
        document.exitFullscreen();
        break;
    }
  }

  render(): void {
    super.render();
    this.displayed.then(() => {
      this.el.classList.add('resizable-grid-box');
      this.full_screen_button = document.createElement('div');
      this.full_screen_button.classList.add('full-screen-button', 'fa', 'fa-expand');
      this.full_screen_button.setAttribute('title', 'Full Screen');
      if (!this.model.get('enable_full_screen')) {
        this.full_screen_button.style.display = "none";
      }
      this.el.appendChild(this.full_screen_button);
      this.full_screen_button.addEventListener('click', (event: any) => {
        this.el.requestFullscreen();
      });
      this.resize_observer.observe(this.el);
    });
  }

}

