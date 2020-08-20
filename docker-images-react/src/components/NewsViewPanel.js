import React from 'react';
import { Link } from 'react-router-dom';

const NewsViewPanel = (props) => (
  <div id="article" className="col-md-12">
    <div className="card ">
      <div className="card-header ">
        <h4 className="card-title">{props.title}</h4>
        <p className="card-category">
          カテゴリー：
          <Link to={`/category?type=${props.type}`}>{props.type}</Link>
        </p>
      </div>
      <div className="card-body ">
        <div className="article_img">
          <img src={props.img_url} alt={props.title}></img>
        </div>
        <div
          dangerouslySetInnerHTML={{
            __html: props.detail,
          }}
        />
      </div>
      <div className="card-footer ">
        <hr></hr>
        <div className="stats">
          <i className="fa fa-history"></i> {props.updated_at}
        </div>
      </div>
    </div>
  </div>
);

export default NewsViewPanel;
