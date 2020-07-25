import React from 'react';
import './App.css';
import NewsAllView from './NewsAllView';
import NewsDetailView from './NewsDetailView';
import NewsLatestView from './NewsLatestView';
import { BrowserRouter, Route } from 'react-router-dom';

class App extends React.Component {
  render() {
    return (
      <BrowserRouter>
        <div>
          <Route exact path="/" component={NewsAllView} />
          <Route path="/latest" component={NewsLatestView} />
          <Route path="/article/:id" component={NewsDetailView} />
        </div>
      </BrowserRouter>
    );
  }
}

export default App;
