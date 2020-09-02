import React from 'react';

const SideBar = () => (
  <div class="sidebar" data-color="white" data-active-color="danger">
    <div class="sidebar-wrapper">
      <ul class="nav">
        <li>
          <a href="/">
            <i class="nc-icon nc-bank"></i>
            <p>ニュース一覧</p>
          </a>
        </li>

        <li>
          <a href="/latest">
            <i class="nc-icon nc-watch-time"></i>
            <p>最新のニュース</p>
          </a>
        </li>
      </ul>
    </div>
  </div>
);

export default SideBar;
