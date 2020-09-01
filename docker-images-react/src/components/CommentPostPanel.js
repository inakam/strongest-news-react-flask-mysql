import React from 'react';

class CommentPostPanel extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      name: '',
      message: '',
    };
    this.submitHandler = this.submitHandler.bind(this);
    this.onChangeMessageHandler = this.onChangeMessageHandler.bind(this);
    this.onChangeNameHandler = this.onChangeNameHandler.bind(this);
  }
  submitHandler(event) {
    event.preventDefault();
    const requestOptions = {
      method: 'POST',
      headers: new Headers({ 'Content-type': 'application/x-www-form-urlencoded' }),
      body: `article_id=${this.props.id}&detail=${this.state.message}&name=${this.state.name}`,
    };
    fetch('/comments', requestOptions)
      .then(function (response) {
        console.log(response);
      })
      .catch(function (error) {
        console.log(error);
      });
    window.location.reload();
  }
  onChangeNameHandler(event) {
    const name = event.target.value;
    this.setState({ name: name });
  }
  onChangeMessageHandler(event) {
    const message = event.target.value;
    this.setState({ message: message });
  }
  render() {
    return (
      <div id="comment-form" className="col-md-12">
        <div className="card card-user">
          <div className="card-header">
            <h4 className="card-title">コメントを投稿する</h4>
          </div>
          <div className="card-body">
            <form onSubmit={this.submitHandler}>
              <div className="row">
                <div className="col-md-3">
                  <div className="form-group">
                    <label>お名前</label>
                    <input
                      type="text"
                      name="name"
                      className="form-control"
                      onChange={this.onChangeNameHandler}
                    />
                  </div>
                </div>
              </div>

              <div className="row">
                <div className="col-md-12">
                  <div className="form-group">
                    <label>メッセージ</label>
                    <textarea
                      name="detail"
                      className="form-control textarea"
                      onChange={this.onChangeMessageHandler}
                    ></textarea>
                  </div>
                </div>
              </div>

              <div className="row">
                <div className="update ml-auto mr-auto">
                  <button type="submit" className="btn btn-primary btn-round">
                    投稿する
                  </button>
                </div>
              </div>
            </form>
          </div>
        </div>
      </div>
    );
  }
}

export default CommentPostPanel;
