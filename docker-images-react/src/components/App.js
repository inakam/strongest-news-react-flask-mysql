import React from 'react';

import { BrowserRouter, Route } from 'react-router-dom';

import NewsAllView from '../container/NewsAllViewContainer';
import NewsLatestView from '../container/NewsLatestViewContainer';
import NewsSearchView from '../container/NewsSearchViewContainer';
import NewsCategoryView from '../container/NewsCategoryViewContainer';
import NewsDetailView from '../container/NewsDetailViewContainer';

class App extends React.Component {
  render() {
    return (
      <BrowserRouter>
        <div>
          <Route exact path="/" component={NewsAllView} />
          <Route path="/search" component={NewsSearchView} />
          <Route path="/category" component={NewsCategoryView} />
          <Route path="/latest" component={NewsLatestView} />
          <Route path="/article/:id" component={NewsDetailView} />
        </div>
      </BrowserRouter>
    );
  }
}

export default App;
