import React from 'react';

const NavBar = () => (
  <nav class="navbar navbar-expand-lg navbar-absolute fixed-top navbar-transparent">
    <div class="container-fluid">
      <div class="navbar-wrapper">
        <div class="navbar-toggle">
          <button type="button" class="navbar-toggler">
            <span class="navbar-toggler-bar bar1"></span>
            <span class="navbar-toggler-bar bar2"></span>
            <span class="navbar-toggler-bar bar3"></span>
          </button>
        </div>
        <a class="navbar-brand" href="/">
          最強ニュースサイト
        </a>
      </div>

      <button
        class="navbar-toggler"
        type="button"
        data-toggle="collapse"
        data-target="#navigation"
        aria-controls="navigation-index"
        aria-expanded="false"
        aria-label="Toggle navigation"
      >
        <span class="navbar-toggler-bar navbar-kebab"></span>
        <span class="navbar-toggler-bar navbar-kebab"></span>
        <span class="navbar-toggler-bar navbar-kebab"></span>
      </button>

      <div class="collapse navbar-collapse justify-content-end" id="navigation">
        <form action="/search" method="GET">
          <div class="input-group no-border">
            <input type="text" name="keyword" class="form-control" placeholder="検索キーワード" />
            <button
              type="submit"
              style={{
                backgroundColor: 'transparent',
                border: 'none',
                cursor: 'pointer',
                outline: 'none',
                padding: 0,
                appearance: 'none',
              }}
            >
              <div class="input-group-text">
                <i class="nc-icon nc-zoom-split"></i>
              </div>
            </button>
          </div>
        </form>
      </div>
    </div>
  </nav>
);

export default NavBar;
