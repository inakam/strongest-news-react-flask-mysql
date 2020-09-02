import React from 'react';

import NewsPanel from '../components/NewsPanel';

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
          <NewsPanel title={item.title} imgUrl={item.img_url} articleId={item.id} key={item.id} />
        ))}
      </div>
    );
  }
}

export default NewsLatestView;
