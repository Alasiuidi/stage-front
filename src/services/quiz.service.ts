import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { catchError, Observable, throwError } from 'rxjs';

@Injectable({ providedIn: 'root' })
export class QuizService {
  // Use the Ingress host (port 80) instead of localhost:8222
  private apiUrl = 'http://gateway.local/quiz/api/test';

  constructor(private http: HttpClient) {}

  getAllTests(): Observable<any> {
    return this.http.get<any>(`${this.apiUrl}`);
  }

  getQuestionsByTest(testId: number): Observable<any> {
    return this.http.get<any>(`${this.apiUrl}/${testId}`);
  }

  submitTest(quizData: any): Observable<any> {
    return this.http.post<any>(`${this.apiUrl}/submit-test`, quizData);
  }

  getTestResults(): Observable<any> {
    return this.http.get<any>(`${this.apiUrl}/test-result`);
  }

  createTest(testData: any): Observable<any> {
    return this.http.post<any>(`${this.apiUrl}`, testData);
  }

  addQuestionToTest(questionData: any): Observable<any> {
    return this.http.post<any>(`${this.apiUrl}/question`, questionData).pipe(
      catchError((error) => {
        console.error('Error adding question:', error);
        return throwError(() => new Error(error.message));
      })
    );
  }

  deleteTest(id: number): Observable<any> {
    return this.http.delete(`${this.apiUrl}/test/${id}`, { responseType: 'text' });
  }

  generateQuestions(description: string): Observable<any> {
    return this.http.post<any>(`${this.apiUrl}/generate-questions`, { description });
  }
}
