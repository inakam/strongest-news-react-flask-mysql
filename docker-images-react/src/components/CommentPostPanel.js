import React from 'react';

class CommentPostPanel extends React.Component {
  submitHandler = (event) => {
    event.preventDefault();
    const requestOptions = {
      method: 'POST',
      headers: new Headers({ 'Content-type': 'application/x-www-form-urlencoded' }),
      body: `article_id=${this.article_id.value}&detail=${this.detail.value}&name=${this.name.value}`,
    };
    fetch('/comments', requestOptions)
      .then(function (response) {
        console.log(response);
      })
      .catch(function (error) {
        console.log(error);
      });
    window.location.reload();
  };
  render() {
    return (
      <div id="comment-form" className="col-md-12">
        <div className="card card-user">
          <div className="card-header">
            <h4 className="card-title">コメントを投稿する</h4>
          </div>
          <div className="card-body">
            <form onSubmit={this.submitHandler} method="POST">
              <input
                type="hidden"
                name="article_id"
                value={this.props.id}
                ref={(input) => {
                  this.article_id = input;
                }}
              />

              <div className="row">
                <div className="col-md-3">
                  <div className="form-group">
                    <label>お名前</label>
                    <input
                      type="text"
                      name="name"
                      className="form-control"
                      ref={(input) => {
                        this.name = input;
                      }}
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
                      ref={(input) => {
                        this.detail = input;
                      }}
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

export default CommentPostPanel