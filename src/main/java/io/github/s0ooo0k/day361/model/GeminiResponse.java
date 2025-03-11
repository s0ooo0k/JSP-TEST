package io.github.s0ooo0k.day361.model;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import jakarta.servlet.http.Part;

import java.util.List;

@JsonIgnoreProperties(ignoreUnknown = true)
public record GeminiResponse(List<Candidate> candidates) {
    @JsonIgnoreProperties(ignoreUnknown = true)
    public record Candidate(Content content) {
        @JsonIgnoreProperties(ignoreUnknown = true)
        public record Content(List<Part> parts) {
            @JsonIgnoreProperties(ignoreUnknown = true)
            public record Part(String text) {}
        }
    }
}


