import React from 'react';
import './App.css';
import { Link } from 'react-router-dom';

import CommentPostPanel from './CommentPostPanel';
import CommentViewPanel from './CommentViewPanel';
import NewsViewPanel from './NewsViewPanel';

class NewsDetailView extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      isLoaded: false,
      item: [],
      commentItem: [],
    };
  }
  componentDidMount() {
    const { params } = this.props.match;
    fetch(`/articles/${params.id}`)
      .then((res) => res.json())
      .then(
        (json) => {
          console.log(json);
          this.setState({
            isLoaded: true,
            item: json,
          });
        },
        (error) => {
          this.setState({
            isLoaded: true,
            error,
          });
        }
      );
    fetch(`/comments/${params.id}`)
      .then((res) => res.json())
      .then(
        (json) => {
          console.log(json);
          this.setState({
            isLoaded: true,
            commentItem: json,
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
    const item = this.state.item;
    return (
      <>
        <div className="row">
          <NewsViewPanel
            title={item.title}
            img_url={item.img_url}
            detail={item.detail}
            updated_at={item.updated_at}
            type={item.type}
          />
        </div>
        <div className="row">
          <CommentViewPanel commentArray={this.state.commentItem} />
        </div>
        <div className="row">
          <CommentPostPanel id={item.id} />
        </div>
      </>
    );
  }
}

export default NewsDetailView;
