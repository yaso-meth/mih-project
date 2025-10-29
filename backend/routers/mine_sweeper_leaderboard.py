from fastapi import APIRouter, HTTPException, status
from pydantic import BaseModel
from supertokens_python.recipe.session.framework.fastapi import verify_session
from supertokens_python.recipe.session import SessionContainer
from fastapi import Depends
import mih_database
import mih_database.mihDbConnections
from mih_database.mihDbObjects import MineSweeperLeaderboard, User
from sqlalchemy import and_, func, literal_column
from sqlalchemy.orm import Session, aliased
from sqlalchemy.exc import IntegrityError, SQLAlchemyError
from datetime import datetime
from sqlalchemy.sql.expression import select

router = APIRouter()

class playerScoreInsertRequest(BaseModel):
    app_id: str
    difficulty: str
    game_time: str
    game_score: float
    played_date: datetime

# get top 20 scores
@router.get("/minesweeper/leaderboard/top20/{difficulty}", tags=["Minesweeper"])
async def get_user_consent(difficulty: str, session: SessionContainer = Depends(verify_session())):#session: SessionContainer = Depends(verify_session())
    dbEngine = mih_database.mihDbConnections.dbAllConnect()
    dbSession = Session(dbEngine)
    try:
        max_score_subquery = (
            dbSession.query(
                MineSweeperLeaderboard.app_id,
                func.max(MineSweeperLeaderboard.game_score).label('max_score')
            )
            .filter(MineSweeperLeaderboard.difficulty == difficulty)
            .group_by(MineSweeperLeaderboard.app_id)
            .subquery('max_scores')
        )
        queryResults = (
            dbSession.query(MineSweeperLeaderboard, User)
            .join(User, User.app_id == MineSweeperLeaderboard.app_id)
            .join(
                max_score_subquery, 
                and_(
                    MineSweeperLeaderboard.app_id == max_score_subquery.c.app_id,
                    MineSweeperLeaderboard.game_score == max_score_subquery.c.max_score
                )
            )
            .filter(MineSweeperLeaderboard.difficulty == difficulty)
            .order_by(MineSweeperLeaderboard.game_score.desc())
            .limit(20)
            .all()
        )
        leaderboardData = []
        if queryResults:
            for playerScore, user in queryResults:
                leaderboardData.append({
                    "app_id": playerScore.app_id,
                    "username": user.username,
                    "proPicUrl":user.pro_pic_path,
                    "difficulty":playerScore.difficulty,
                    "game_time":playerScore.game_time,
                    "game_score":playerScore.game_score,
                    "played_date":playerScore.played_date,
                })
            return leaderboardData
        else:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail="No Score available for user."
            )
    except HTTPException as http_exc:
        raise http_exc
    except Exception as e:
        print(f"An error occurred during the ORM query: {e}")
        if dbSession.is_active:
            dbSession.rollback()
        raise HTTPException(
                status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
                detail="Failed to retrieve records due to an internal server error."
            )
    finally:
        dbSession.close()

@router.get("/minesweeper/leaderboard/top_score/{difficulty}/{app_id}", tags=["Minesweeper"])
async def get_user_consent(app_id: str,
                           difficulty: str,
                           session: SessionContainer = Depends(verify_session())):#session: SessionContainer = Depends(verify_session())
    dbEngine = mih_database.mihDbConnections.dbAllConnect()
    dbSession = Session(dbEngine)
    try:
        queryResults =(dbSession.query(MineSweeperLeaderboard, User)
                    .join(User, User.app_id == MineSweeperLeaderboard.app_id)
                    .filter(
                        and_(
                            MineSweeperLeaderboard.app_id == app_id,
                            MineSweeperLeaderboard.difficulty == difficulty
                        )
                    )
                    .order_by(MineSweeperLeaderboard.game_score.desc())
                    .all())
        if not queryResults:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail="No scores found for this user and difficulty level."
            )
        leaderboard_data = []
        for player_score, user in queryResults:
            score_data = {
                "app_id": player_score.app_id,
                "username": user.username,
                "proPicUrl": user.pro_pic_path,
                "difficulty": player_score.difficulty,
                "game_time": player_score.game_time,
                "game_score": player_score.game_score,
                "played_date": player_score.played_date,
            }
            leaderboard_data.append(score_data)
        return leaderboard_data
    except HTTPException as http_exc:
        raise http_exc
    except Exception as e:
        print(f"An error occurred during the ORM query: {e}")
        if dbSession.is_active:
            dbSession.rollback()
        raise HTTPException(
                status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
                detail="Failed to retrieve records due to an internal server error."
            )
    finally:
        dbSession.close()

@router.post("/minesweeper/leaderboard/player_score/insert/",
             tags=["Minesweeper"],
             status_code=status.HTTP_201_CREATED)
async def insert_user_consent(itemRequest: playerScoreInsertRequest,
                              session: SessionContainer = Depends(verify_session())):#session: SessionContainer = Depends(verify_session())
    dbEngine = mih_database.mihDbConnections.dbAllConnect()
    dbSession = Session(dbEngine)
    try:
        newPlayerScore = MineSweeperLeaderboard(
            app_id = itemRequest.app_id,
            difficulty = itemRequest.difficulty,
            game_time = itemRequest.game_time,
            game_score = itemRequest.game_score,
            played_date = itemRequest.played_date,
        )
        dbSession.add(newPlayerScore)
        dbSession.commit()
        dbSession.refresh(newPlayerScore)
        return {"message": "Successfully Created Player Score Record"}
    except IntegrityError as e:
        dbSession.rollback()
        raise HTTPException(
            status_code=status.HTTP_409_CONFLICT, # 409 Conflict is often suitable for constraint errors
            detail=f"Data integrity error: The provided data violates a database constraint. Details: {e.orig}"
        ) from e
    except SQLAlchemyError as e:
        dbSession.rollback()
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"A database error occurred during insertion. Details: {e.orig}"
        ) from e
    except Exception as e:
        dbSession.rollback()
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"An unexpected error occurred: {e}"
        ) from e
    finally:
        dbSession.close()
