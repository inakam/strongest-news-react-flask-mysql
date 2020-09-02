import React from 'react';
import { Link } from 'react-router-dom';

import CommentPostPanel from '../components/CommentPostPanel';
import CommentViewPanel from '../components/CommentViewPanel';
import NewsViewPanel from '../components/NewsViewPanel';

class NewsDetailView extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      isLoaded: false,
      article: {
        title: '',
        img_url: '',
        detail: '',
        updated_at: null,
        type: '',
      },
      comments: [],
    };
  }
  componentDidMount() {
    const { params } = this.props.match;
    this.fetchArticle(params.id);
    this.fetchComments(params.id);
  }
  fetchArticle(articleId) {
    fetch(`/articles/${articleId}`)
      .then((res) => res.json())
      .then(
        (json) => {
          console.log('article', json);
          console.log(json);
          this.setState({
            isLoaded: true,
            article: json,
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
  fetchComments(articleId) {
    fetch(`/comments/${articleId}`)
      .then((res) => res.json())
      .then(
        (json) => {
          console.log('comments', json);
          this.setState({
            isLoaded: true,
            comments: json,
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
    const { article, comments } = this.state;
    return (
      <>
        <div className="row">
          <NewsViewPanel
            title={article.title}
            img_url={article.img_url}
            detail={article.detail}
            updated_at={article.updated_at}
            type={article.type}
          />
        </div>
        <div className="row">
          <CommentViewPanel comments={comments} />
        </div>
        <div className="row">
          <CommentPostPanel id={article.id} />
        </div>
      </>
    );
  }
}

export default NewsDetailView;
