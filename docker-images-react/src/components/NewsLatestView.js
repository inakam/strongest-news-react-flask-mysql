import React from 'react';
import './App.css';
import NewsPanel from './NewsPanel';

class NewsLatestView extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      isLoaded: false,
      items: [],
    };
  }
  componentDidMount() {
    fetch('/titles?limit=9')
      .then((res) => res.json())
      .then(
        (json) => {
          console.log(json);
          this.setState({
            isLoaded: true,
            items: json,
          });
        },
        (error) => {
          this.setState({
            isLoaded: true,
            error,
          });
        }
      );
  }
  render() {
    return (
      <div className="row">
        {this.state.items.map((item) => (
          <NewsPanel title={item.title} img_url={item.img_url} page_url={item.id} key={item.id} />
        ))}
      </div>
    );
  }
}

export default NewsLatestView;
